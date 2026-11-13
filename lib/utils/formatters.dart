const List<String> _weekdays = [
  'Thứ 2',
  'Thứ 3',
  'Thứ 4',
  'Thứ 5',
  'Thứ 6',
  'Thứ 7',
  'Chủ nhật',
];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// "15:00"
String formatTime(DateTime time) =>
    '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';

/// "15:00 – 16:30"
String formatTimeRange(DateTime start, int durationMinutes) {
  final end = start.add(Duration(minutes: durationMinutes));
  return '${formatTime(start)} – ${formatTime(end)}';
}

/// "20/11"
String formatShortDate(DateTime date) =>
    '${_twoDigits(date.day)}/${_twoDigits(date.month)}';

/// "Thứ 5, 20/11"
String formatDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${formatShortDate(date)}';

/// "Thứ 5, 20/11/2026"
String formatFullDate(DateTime date) =>
    '${formatDate(date)}/${date.year}';

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// "Hôm nay" / "Ngày mai" / "Thứ 5, 20/11"
String friendlyDay(DateTime date, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final diff = target.difference(today).inDays;
  if (diff == 0) return 'Hôm nay';
  if (diff == 1) return 'Ngày mai';
  if (diff == 2) return 'Ngày kia';
  return formatDate(date);
}

/// "Vừa xong", "2 giờ trước", "Hôm qua", "20/11/2026"
String timeAgo(DateTime time, DateTime now) {
  final diff = now.difference(time);
  if (diff.inSeconds < 60) return 'Vừa xong';
  if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
  if (diff.inHours < 24 && _isSameDay(time, now)) {
    return '${diff.inHours} giờ trước';
  }
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(time.year, time.month, time.day);
  final dayDiff = today.difference(day).inDays;
  if (dayDiff == 1) return 'Hôm qua';
  if (dayDiff > 1 && dayDiff < 7) return '$dayDiff ngày trước';
  return '${formatShortDate(time)}/${time.year}';
}

/// "Còn 4 giờ" / "Còn 2 ngày" / "Đã hết hạn"
String timeLeft(DateTime deadline, DateTime now) {
  final diff = deadline.difference(now);
  if (diff.isNegative) return 'Đã hết hạn';
  if (diff.inMinutes < 60) {
    final minutes = diff.inMinutes <= 0 ? 1 : diff.inMinutes;
    return 'Còn $minutes phút';
  }
  if (diff.inHours < 24) return 'Còn ${diff.inHours} giờ';
  return 'Còn ${diff.inDays} ngày';
}

/// "11/2026" cho thống kê hồ sơ.
String formatMonthYear(DateTime date) =>
    '${_twoDigits(date.month)}/${date.year}';

String greetingFor(DateTime time) {
  if (time.hour < 11) return 'Chào buổi sáng';
  if (time.hour < 14) return 'Chào buổi trưa';
  if (time.hour < 18) return 'Chào buổi chiều';
  return 'Chào buổi tối';
}

String durationLabel(int minutes) {
  if (minutes < 60) return '$minutes phút';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0 ? '$hours giờ' : '$hours giờ $rest phút';
}
