/// Các trạng thái trong vòng đời của một lời mời ghép cặp.
enum SwapStatus {
  pending,
  accepted,
  scheduled,
  completed,
  rejected,
  expired,
  cancelled,
}

extension SwapStatusX on SwapStatus {
  String get label {
    switch (this) {
      case SwapStatus.pending:
        return 'Đang chờ';
      case SwapStatus.accepted:
        return 'Đã chấp nhận';
      case SwapStatus.scheduled:
        return 'Đã đặt lịch';
      case SwapStatus.completed:
        return 'Đã hoàn thành';
      case SwapStatus.rejected:
        return 'Đã từ chối';
      case SwapStatus.expired:
        return 'Hết hạn';
      case SwapStatus.cancelled:
        return 'Đã huỷ';
    }
  }

  String get description {
    switch (this) {
      case SwapStatus.pending:
        return 'Đang chờ phản hồi';
      case SwapStatus.accepted:
        return 'Hai bạn đã ghép đôi, hãy chọn lịch học';
      case SwapStatus.scheduled:
        return 'Buổi trao đổi đã được lên lịch';
      case SwapStatus.completed:
        return 'Buổi học đã kết thúc';
      case SwapStatus.rejected:
        return 'Lời mời đã bị từ chối';
      case SwapStatus.expired:
        return 'Lời mời quá hạn phản hồi';
      case SwapStatus.cancelled:
        return 'Buổi trao đổi đã bị huỷ';
    }
  }

  bool get isPending => this == SwapStatus.pending;

  bool get isActive =>
      this == SwapStatus.accepted || this == SwapStatus.scheduled;

  bool get isFinished =>
      this == SwapStatus.completed ||
      this == SwapStatus.rejected ||
      this == SwapStatus.expired ||
      this == SwapStatus.cancelled;
}

enum SessionMode { offline, online }

extension SessionModeX on SessionMode {
  String get label => this == SessionMode.offline ? 'Trực tiếp' : 'Trực tuyến';

  String get shortLabel =>
      this == SessionMode.offline ? 'Offline' : 'Online';
}

enum SessionStatus { scheduled, completed, cancelled }

extension SessionStatusX on SessionStatus {
  String get label {
    switch (this) {
      case SessionStatus.scheduled:
        return 'Sắp diễn ra';
      case SessionStatus.completed:
        return 'Đã hoàn thành';
      case SessionStatus.cancelled:
        return 'Đã huỷ';
    }
  }
}

class SwapSession {
  final String id;
  final DateTime startTime;
  final int durationMinutes;
  final String location;
  final SessionMode mode;
  final String note;
  final SessionStatus status;
  final int rescheduleCount;
  final List<DateTime> previousStartTimes;

  const SwapSession({
    required this.id,
    required this.startTime,
    this.durationMinutes = 60,
    this.location = 'Thư viện tầng 3',
    this.mode = SessionMode.offline,
    this.note = '',
    this.status = SessionStatus.scheduled,
    this.rescheduleCount = 0,
    this.previousStartTimes = const [],
  });

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

  SwapSession copyWith({
    DateTime? startTime,
    int? durationMinutes,
    String? location,
    SessionMode? mode,
    String? note,
    SessionStatus? status,
    int? rescheduleCount,
    List<DateTime>? previousStartTimes,
  }) {
    return SwapSession(
      id: id,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      mode: mode ?? this.mode,
      note: note ?? this.note,
      status: status ?? this.status,
      rescheduleCount: rescheduleCount ?? this.rescheduleCount,
      previousStartTimes: previousStartTimes ?? this.previousStartTimes,
    );
  }
}

class Review {
  final String id;
  final String sessionId;
  final String matchId;
  final String fromUserId;
  final String toUserId;
  final int rating;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.sessionId,
    required this.matchId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    this.comment = '',
    this.tags = const [],
    required this.createdAt,
  });
}

/// Một lời mời / cặp ghép giữa hai sinh viên.
class SwapRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;
  final DateTime expiresAt;
  final SwapStatus status;
  final List<SwapSession> sessions;
  final List<Review> reviews;
  final DateTime? respondedAt;
  final String? cancelReason;

  const SwapRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.expiresAt,
    this.status = SwapStatus.pending,
    this.sessions = const [],
    this.reviews = const [],
    this.respondedAt,
    this.cancelReason,
  });

  bool involves(String userId) =>
      senderId == userId || receiverId == userId;

  String otherUserId(String me) => senderId == me ? receiverId : senderId;

  bool isSender(String me) => senderId == me;

  SwapSession? get latestSession {
    if (sessions.isEmpty) return null;
    final active = sessions
        .where((session) => session.status == SessionStatus.scheduled)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    if (active.isNotEmpty) return active.first;

    final sorted = [...sessions]
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    return sorted.first;
  }

  SwapSession? get completedSession {
    final done = sessions
        .where((session) => session.status == SessionStatus.completed)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    return done.isEmpty ? null : done.first;
  }

  Review? reviewBy(String userId) {
    for (final review in reviews) {
      if (review.fromUserId == userId) return review;
    }
    return null;
  }

  Review? reviewAbout(String userId) {
    for (final review in reviews) {
      if (review.toUserId == userId) return review;
    }
    return null;
  }

  bool hasReviewed(String userId) => reviewBy(userId) != null;

  bool needsMyReview(String userId) =>
      status == SwapStatus.completed &&
      completedSession != null &&
      !hasReviewed(userId);

  bool get isMutualReviewComplete =>
      reviews.length >= 2;

  SwapRequest copyWith({
    SwapStatus? status,
    List<SwapSession>? sessions,
    List<Review>? reviews,
    DateTime? respondedAt,
    String? cancelReason,
  }) {
    return SwapRequest(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      reviews: reviews ?? this.reviews,
      respondedAt: respondedAt ?? this.respondedAt,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }
}

/// Các nhãn đánh giá nhanh sau buổi học.
class ReviewTags {
  ReviewTags._();

  static const List<String> positive = [
    'Đúng giờ',
    'Giải thích dễ hiểu',
    'Thân thiện',
    'Chuẩn bị chu đáo',
    'Kiên nhẫn',
    'Truyền cảm hứng',
  ];

  static const List<String> constructive = [
    'Cần đúng giờ hơn',
    'Chưa chuẩn bị kỹ',
    'Cần nói chậm hơn',
  ];
}
