import 'package:flutter/foundation.dart';

import '../models/swap_request.dart';
import '../models/user.dart';
import '../services/matching_service.dart';
import '../services/sample_data.dart';

/// Một buổi học kèm thông tin lời mời và đối phương để hiển thị trong lịch.
class SessionEntry {
  final SwapRequest request;
  final SwapSession session;
  final User partner;

  const SessionEntry({
    required this.request,
    required this.session,
    required this.partner,
  });
}

/// Nguồn dữ liệu duy nhất (in-memory) cho toàn bộ app demo.
class AppState extends ChangeNotifier {
  AppState({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final MatchingService _matchingService = const MatchingService();

  User? _currentUser;
  List<User> _users = [];
  List<SwapRequest> _requests = [];
  final Set<String> _skippedUserIds = {};

  DateTime get now => _clock();
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<User> get users => List.unmodifiable(_users);
  List<SwapRequest> get requests => List.unmodifiable(_requests);
  Set<String> get skippedUserIds => Set.unmodifiable(_skippedUserIds);

  // ---------------------------------------------------------------------------
  // Đăng nhập / dữ liệu mẫu
  // ---------------------------------------------------------------------------

  void loginDemo() {
    _currentUser = SampleData.demoUser;
    _resetToSeed();
  }

  /// Bắt đầu phiên với hồ sơ vừa tạo ở màn hình onboarding.
  void startSession(User user) {
    _currentUser = user;
    _resetToSeed();
  }

  void logout() {
    _currentUser = null;
    _users = [];
    _requests = [];
    _skippedUserIds.clear();
    notifyListeners();
  }

  /// Đặt lại dữ liệu demo nhưng giữ nguyên hồ sơ hiện tại.
  void resetDemo() {
    if (_currentUser == null) return;
    _resetToSeed();
  }

  void _resetToSeed() {
    final user = _currentUser!;
    _users = [...SampleData.users];
    _requests = SampleData.seedRequests(
      currentUserId: user.id,
      now: now,
    );
    _skippedUserIds.clear();
    notifyListeners();
  }

  void updateCurrentUser(User updated) {
    if (_currentUser == null) return;
    _currentUser = updated;
    final index = _users.indexWhere((user) => user.id == updated.id);
    if (index >= 0) {
      _users[index] = updated;
    }
    notifyListeners();
  }

  User userById(String id) {
    final me = _currentUser;
    if (me != null && me.id == id) return me;
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return SampleData.userById(id);
  }

  User get _me => _currentUser!;

  // ---------------------------------------------------------------------------
  // Trạng thái hiệu lực (tự động hết hạn lời mời chờ quá 48 giờ)
  // ---------------------------------------------------------------------------

  SwapStatus statusOf(SwapRequest request) {
    if (request.status == SwapStatus.pending &&
        now.isAfter(request.expiresAt)) {
      return SwapStatus.expired;
    }
    return request.status;
  }

  void expireOverdueRequests() {
    var changed = false;
    final updated = <SwapRequest>[];
    for (final request in _requests) {
      if (request.status == SwapStatus.pending &&
          now.isAfter(request.expiresAt)) {
        updated.add(request.copyWith(status: SwapStatus.expired));
        changed = true;
      } else {
        updated.add(request);
      }
    }
    if (changed) {
      _requests = updated;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Truy vấn lời mời / lịch
  // ---------------------------------------------------------------------------

  List<SwapRequest> get myRequests {
    final me = _currentUser;
    if (me == null) return const [];
    final list = _requests.where((r) => r.involves(me.id)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<SwapRequest> get incomingPending {
    final me = _currentUser;
    if (me == null) return const [];
    return myRequests
        .where((r) =>
            r.receiverId == me.id && statusOf(r) == SwapStatus.pending)
        .toList();
  }

  List<SwapRequest> get outgoingPending {
    final me = _currentUser;
    if (me == null) return const [];
    return myRequests
        .where((r) =>
            r.senderId == me.id && statusOf(r) == SwapStatus.pending)
        .toList();
  }

  List<SwapRequest> get acceptedMatches {
    return myRequests
        .where((r) => statusOf(r) == SwapStatus.accepted)
        .toList();
  }

  List<SwapRequest> get scheduledMatches {
    return myRequests
        .where((r) => statusOf(r) == SwapStatus.scheduled)
        .toList();
  }

  /// Lịch sử gồm mọi lời mời đã vượt qua trạng thái chờ.
  List<SwapRequest> get historyRequests {
    return myRequests
        .where((r) => statusOf(r) != SwapStatus.pending)
        .toList();
  }

  List<SwapRequest> get completedMatches {
    return myRequests
        .where((r) => statusOf(r) == SwapStatus.completed)
        .toList();
  }

  int get pendingIncomingCount => incomingPending.length;

  int get upcomingSessionCount => upcomingSessions.length;

  int get needsReviewCount => completedMatches
      .where((request) => request.needsMyReview(_me.id))
      .length;

  List<SessionEntry> get upcomingSessions {
    final me = _currentUser;
    if (me == null) return const [];
    final entries = <SessionEntry>[];
    for (final request in _requests) {
      if (statusOf(request) != SwapStatus.scheduled) continue;
      for (final session in request.sessions) {
        if (session.status == SessionStatus.scheduled &&
            session.startTime.isAfter(now)) {
          entries.add(SessionEntry(
            request: request,
            session: session,
            partner: userById(request.otherUserId(me.id)),
          ));
        }
      }
    }
    entries.sort((a, b) => a.session.startTime.compareTo(b.session.startTime));
    return entries;
  }

  List<SessionEntry> get completedSessions {
    final me = _currentUser;
    if (me == null) return const [];
    final entries = <SessionEntry>[];
    for (final request in _requests) {
      for (final session in request.sessions) {
        if (session.status == SessionStatus.completed) {
          entries.add(SessionEntry(
            request: request,
            session: session,
            partner: userById(request.otherUserId(me.id)),
          ));
        }
      }
    }
    entries.sort((a, b) => b.session.startTime.compareTo(a.session.startTime));
    return entries;
  }

  SwapRequest? requestById(String id) {
    for (final request in _requests) {
      if (request.id == id) return request;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Khám phá & ghép cặp
  // ---------------------------------------------------------------------------

  List<MatchingResult> get recommendations {
    final me = _currentUser;
    if (me == null) return const [];
    final candidates = _users
        .where((user) =>
            user.id != me.id &&
            !_skippedUserIds.contains(user.id) &&
            !_hasBlockingRequest(user.id))
        .toList();
    return _matchingService.getRecommendations(
      currentUser: me,
      candidates: candidates,
    );
  }

  bool _hasBlockingRequest(String userId) {
    final me = _currentUser;
    if (me == null) return false;
    for (final request in _requests) {
      if (!request.involves(me.id) || !request.involves(userId)) continue;
      final status = statusOf(request);
      if (status == SwapStatus.pending ||
          status == SwapStatus.accepted ||
          status == SwapStatus.scheduled ||
          status == SwapStatus.completed) {
        return true;
      }
    }
    return false;
  }

  bool hasOpenRequestWith(String userId) {
    final me = _currentUser;
    if (me == null) return false;
    return _requests.any((request) =>
        request.involves(me.id) &&
        request.involves(userId) &&
        (statusOf(request).isPending || statusOf(request).isActive));
  }

  void skipUser(String userId) {
    _skippedUserIds.add(userId);
    notifyListeners();
  }

  void unskipUser(String userId) {
    if (_skippedUserIds.remove(userId)) {
      notifyListeners();
    }
  }

  void resetSkippedUsers() {
    _skippedUserIds.clear();
    notifyListeners();
  }

  SwapRequest? sendRequest(User target, {String? message}) {
    final me = _currentUser;
    if (me == null) return null;
    if (hasOpenRequestWith(target.id)) return null;

    final defaultMessage =
        'Chào ${target.name.split(' ').last}, mình thấy chúng ta có thể trao đổi kỹ năng. '
        'Mình có thể dạy ${me.teachingSkills.isEmpty ? 'kỹ năng của mình' : me.teachingSkills.first.name}, '
        'học lại ${me.learningSkills.isEmpty ? 'điều bạn đang có' : me.learningSkills.first.name}. '
        'Bạn thấy thế nào?';

    final request = SwapRequest(
      id: 'req-${now.microsecondsSinceEpoch}',
      senderId: me.id,
      receiverId: target.id,
      message: message?.trim().isNotEmpty == true
          ? message!.trim()
          : defaultMessage,
      createdAt: now,
      expiresAt: now.add(const Duration(hours: 48)),
    );

    _requests.insert(0, request);
    _skippedUserIds.remove(target.id);
    notifyListeners();
    return request;
  }

  bool respondToRequest(String requestId, {required bool accept}) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index < 0) return false;
    final request = _requests[index];
    if (statusOf(request) != SwapStatus.pending) return false;

    _requests[index] = request.copyWith(
      status: accept ? SwapStatus.accepted : SwapStatus.rejected,
      respondedAt: now,
    );
    notifyListeners();
    return true;
  }

  /// Dùng cho demo: giả lập đối phương đồng ý lời mời đã gửi.
  bool demoPartnerAccepts(String requestId) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index < 0) return false;
    final request = _requests[index];
    if (statusOf(request) != SwapStatus.pending) return false;
    _requests[index] = request.copyWith(
      status: SwapStatus.accepted,
      respondedAt: now,
    );
    notifyListeners();
    return true;
  }

  bool cancelMatch(String requestId, {String? reason}) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index < 0) return false;
    final request = _requests[index];
    final status = statusOf(request);
    if (status.isFinished) return false;

    final sessions = request.sessions.map((session) {
      if (session.status == SessionStatus.scheduled) {
        return session.copyWith(status: SessionStatus.cancelled);
      }
      return session;
    }).toList();

    _requests[index] = request.copyWith(
      status: SwapStatus.cancelled,
      sessions: sessions,
      cancelReason: reason ?? 'Đã huỷ bởi ${_me.name}',
    );
    notifyListeners();
    return true;
  }

  /// Đặt lịch mới hoặc đổi lịch cho một cặp đã chấp nhận.
  SwapSession? scheduleSession(
    String requestId, {
    required DateTime startTime,
    required int durationMinutes,
    required String location,
    required SessionMode mode,
    String note = '',
  }) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index < 0) return null;
    final request = _requests[index];
    final status = statusOf(request);
    if (status != SwapStatus.accepted && status != SwapStatus.scheduled) {
      return null;
    }

    final sessions = [...request.sessions];
    final activeIndex = sessions.indexWhere(
      (session) => session.status == SessionStatus.scheduled,
    );

    late SwapSession saved;
    if (activeIndex >= 0) {
      final old = sessions[activeIndex];
      saved = old.copyWith(
        startTime: startTime,
        durationMinutes: durationMinutes,
        location: location,
        mode: mode,
        note: note,
        status: SessionStatus.scheduled,
        rescheduleCount: old.rescheduleCount + 1,
        previousStartTimes: [...old.previousStartTimes, old.startTime],
      );
      sessions[activeIndex] = saved;
    } else {
      saved = SwapSession(
        id: '${request.id}-s${sessions.length + 1}',
        startTime: startTime,
        durationMinutes: durationMinutes,
        location: location,
        mode: mode,
        note: note,
      );
      sessions.add(saved);
    }

    _requests[index] = request.copyWith(
      status: SwapStatus.scheduled,
      sessions: sessions,
    );
    notifyListeners();
    return saved;
  }

  bool completeSession(String requestId) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index < 0) return false;
    final request = _requests[index];
    if (statusOf(request) != SwapStatus.scheduled) return false;

    final sessions = [...request.sessions];
    final sessionIndex = sessions.indexWhere(
      (session) => session.status == SessionStatus.scheduled,
    );
    if (sessionIndex < 0) return false;
    final session = sessions[sessionIndex];
    sessions[sessionIndex] = session.copyWith(
      status: SessionStatus.completed,
    );

    // Demo: đối phương gửi đánh giá ngay sau khi buổi học kết thúc.
    final reviews = [...request.reviews];
    final partnerId = request.otherUserId(_me.id);
    if (request.reviewBy(partnerId) == null) {
      reviews.add(_mockPartnerReview(
        request: request,
        session: session,
        partnerId: partnerId,
      ));
    }

    _requests[index] = request.copyWith(
      status: SwapStatus.completed,
      sessions: sessions,
      reviews: reviews,
    );
    notifyListeners();
    return true;
  }

  Review _mockPartnerReview({
    required SwapRequest request,
    required SwapSession session,
    required String partnerId,
  }) {
    final partner = userById(partnerId);
    final rating = partner.rating >= 4.8 ? 5 : 4;
    final taught = _me.teachingSkills.isEmpty
        ? 'buổi học'
        : _me.teachingSkills.first.name;
    return Review(
      id: '${request.id}-review-$partnerId',
      sessionId: session.id,
      matchId: request.id,
      fromUserId: partnerId,
      toUserId: _me.id,
      rating: rating,
      comment: rating == 5
          ? 'Buổi trao đổi rất chất lượng! ${_me.name} giải thích $taught rõ ràng, đúng giờ và chuẩn bị tốt.'
          : 'Buổi học ổn, ${_me.name} giải thích dễ hiểu. Lần sau mình muốn có thêm bài tập thực hành.',
      tags: rating == 5
          ? const ['Đúng giờ', 'Giải thích dễ hiểu', 'Thân thiện']
          : const ['Giải thích dễ hiểu'],
      createdAt: now,
    );
  }

  bool submitReview(
    String requestId, {
    required int rating,
    required String comment,
    List<String> tags = const [],
  }) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index < 0) return false;
    final request = _requests[index];
    if (request.status != SwapStatus.completed) return false;
    if (request.hasReviewed(_me.id)) return false;

    final session = request.completedSession ?? request.latestSession;
    if (session == null) return false;

    final review = Review(
      id: '${request.id}-review-${_me.id}',
      sessionId: session.id,
      matchId: request.id,
      fromUserId: _me.id,
      toUserId: request.otherUserId(_me.id),
      rating: rating,
      comment: comment.trim(),
      tags: tags,
      createdAt: now,
    );

    _requests[index] = request.copyWith(reviews: [...request.reviews, review]);
    notifyListeners();
    return true;
  }

  // ---------------------------------------------------------------------------
  // Đánh giá & thống kê
  // ---------------------------------------------------------------------------

  List<Review> reviewsAbout(String userId) {
    final list = <Review>[];
    for (final request in _requests) {
      for (final review in request.reviews) {
        if (review.toUserId == userId) list.add(review);
      }
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<Review> get reviewsAboutMe {
    final me = _currentUser;
    return me == null ? const [] : reviewsAbout(me.id);
  }

  double ratingOf(String userId) {
    final user = userById(userId);
    final reviews = reviewsAbout(userId);
    if (reviews.isEmpty) return user.rating;
    final totalRatings =
        reviews.fold<int>(0, (sum, review) => sum + review.rating);
    final baseTotal = user.rating * user.reviewCount;
    final count = user.reviewCount + reviews.length;
    if (count == 0) return 0;
    return (baseTotal + totalRatings) / count;
  }

  int reviewCountOf(String userId) {
    final user = userById(userId);
    return user.reviewCount + reviewsAbout(userId).length;
  }

  int get completedSessionCount {
    return completedSessions.length;
  }

  int get partnerCount {
    final me = _currentUser;
    if (me == null) return 0;
    return completedMatches
        .map((request) => request.otherUserId(me.id))
        .toSet()
        .length;
  }

  List<MatchingResult> get topMatches => recommendations.take(3).toList();
}
