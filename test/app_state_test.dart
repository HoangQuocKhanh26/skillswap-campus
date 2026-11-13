import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap_campus/models/swap_request.dart';
import 'package:skillswap_campus/services/sample_data.dart';
import 'package:skillswap_campus/state/app_state.dart';

void main() {
  final fixedNow = DateTime(2026, 11, 13, 9, 0);

  AppState buildState() {
    final state = AppState(clock: () => fixedNow);
    state.loginDemo();
    return state;
  }

  group('Dữ liệu demo', () {
    test('Có đủ 18 hồ sơ mẫu và đủ các nhánh vòng đời', () {
      final state = buildState();

      expect(SampleData.users.length, 18);
      expect(state.currentUser?.name, 'Ngọc Anh');
      expect(state.incomingPending.length, 2);
      expect(state.outgoingPending.length, 1);
      expect(state.upcomingSessions.length, 2);
      expect(state.completedSessions.length, 2);
      expect(state.historyRequests.length, 8);
      expect(state.needsReviewCount, 1);
      expect(state.recommendations, isNotEmpty);
    });

    test('Các trạng thái trong lịch sử bao phủ đủ nhánh', () {
      final state = buildState();
      final statuses = state.historyRequests
          .map(state.statusOf)
          .toSet();

      expect(statuses, contains(SwapStatus.accepted));
      expect(statuses, contains(SwapStatus.scheduled));
      expect(statuses, contains(SwapStatus.completed));
      expect(statuses, contains(SwapStatus.rejected));
      expect(statuses, contains(SwapStatus.expired));
      expect(statuses, contains(SwapStatus.cancelled));
    });
  });

  group('Vòng đời ghép đôi', () {
    test('Chấp nhận → đặt lịch → hoàn thành → đánh giá', () {
      final state = buildState();
      final request = state.requestById('seed-02')!;
      final partnerId = request.otherUserId(state.currentUser!.id);

      expect(state.respondToRequest('seed-02', accept: true), isTrue);
      expect(state.requestById('seed-02')!.status, SwapStatus.accepted);

      final start = fixedNow.add(const Duration(days: 1, hours: 2));
      final session = state.scheduleSession(
        'seed-02',
        startTime: start,
        durationMinutes: 60,
        location: 'Thư viện tầng 3',
        mode: SessionMode.offline,
        note: 'Học speaking',
      );

      expect(session, isNotNull);
      expect(state.requestById('seed-02')!.status, SwapStatus.scheduled);
      expect(
        state.upcomingSessions.any((entry) =>
            entry.request.id == 'seed-02' &&
            entry.session.startTime == start),
        isTrue,
      );

      expect(state.completeSession('seed-02'), isTrue);
      final completed = state.requestById('seed-02')!;
      expect(completed.status, SwapStatus.completed);
      expect(completed.reviews.length, 1);
      expect(completed.reviewBy(partnerId), isNotNull);
      expect(completed.needsMyReview(state.currentUser!.id), isTrue);

      final ratingBefore = state.ratingOf(state.currentUser!.id);
      expect(
        state.submitReview(
          'seed-02',
          rating: 5,
          comment: 'Rất hữu ích',
          tags: const ['Đúng giờ'],
        ),
        isTrue,
      );

      final reviewed = state.requestById('seed-02')!;
      expect(reviewed.reviews.length, 2);
      expect(reviewed.needsMyReview(state.currentUser!.id), isFalse);
      expect(state.ratingOf(state.currentUser!.id), greaterThanOrEqualTo(ratingBefore));
    });

    test('Từ chối lời mời sẽ chuyển sang lịch sử', () {
      final state = buildState();
      final before = state.historyRequests.length;

      expect(state.respondToRequest('seed-03', accept: false), isTrue);

      expect(state.requestById('seed-03')!.status, SwapStatus.rejected);
      expect(state.incomingPending.length, 1);
      expect(state.historyRequests.length, before + 1);
    });

    test('Lời mời tự hết hạn sau 48 giờ', () {
      var current = fixedNow;
      final state = AppState(clock: () => current);
      state.loginDemo();

      final request = state.requestById('seed-03')!;
      expect(request.status, SwapStatus.pending);

      current = current.add(const Duration(hours: 5));
      expect(state.statusOf(request), SwapStatus.expired);
      expect(
        state.incomingPending.any((item) => item.id == 'seed-03'),
        isFalse,
      );

      state.expireOverdueRequests();
      expect(state.requestById('seed-03')!.status, SwapStatus.expired);
    });

    test('Đổi lịch lưu lại lịch cũ và tăng bộ đếm', () {
      final state = buildState();
      final oldSession = state.requestById('seed-05')!.latestSession!;
      final newTime = oldSession.startTime.add(const Duration(days: 1));

      final updated = state.scheduleSession(
        'seed-05',
        startTime: newTime,
        durationMinutes: 120,
        location: 'Căng tin A',
        mode: SessionMode.offline,
      );

      expect(updated, isNotNull);
      expect(updated!.startTime, newTime);
      expect(updated.durationMinutes, 120);
      expect(updated.rescheduleCount, 1);
      expect(updated.previousStartTimes, contains(oldSession.startTime));
      expect(state.requestById('seed-05')!.status, SwapStatus.scheduled);
    });

    test('Huỷ lịch cập nhật lịch sử và danh sách sắp tới', () {
      final state = buildState();
      final before = state.upcomingSessions.length;

      expect(state.cancelMatch('seed-05', reason: 'Bận thi'), isTrue);

      final cancelled = state.requestById('seed-05')!;
      expect(cancelled.status, SwapStatus.cancelled);
      expect(cancelled.cancelReason, 'Bận thi');
      expect(cancelled.latestSession?.status, SessionStatus.cancelled);
      expect(state.upcomingSessions.length, before - 1);
    });

    test('Gửi lời mời mới và chặn gửi trùng', () {
      final state = buildState();
      final candidate = state.recommendations.first.user;

      final request = state.sendRequest(candidate, message: 'Cùng học nhé');
      expect(request, isNotNull);
      expect(request!.status, SwapStatus.pending);
      expect(state.outgoingPending.length, 2);
      expect(state.sendRequest(candidate), isNull);
      expect(
        state.recommendations.any((result) => result.user.id == candidate.id),
        isFalse,
      );
    });
  });

  group('Ghép cặp', () {
    test('Điểm phần trăm và trao đổi hai chiều', () {
      final state = buildState();
      final mutual = state.recommendations.where((result) => result.isMutual);

      expect(mutual, isNotEmpty);
      for (final result in mutual) {
        expect(result.theyTeachYou, isNotEmpty);
        expect(result.youTeachThem, isNotEmpty);
        expect(result.percent, greaterThan(0));
        expect(result.percent, lessThanOrEqualTo(100));
      }
    });
  });
}
