import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/user_avatar.dart';

class ScheduleSessionScreen extends StatefulWidget {
  final SwapRequest request;

  const ScheduleSessionScreen({
    super.key,
    required this.request,
  });

  @override
  State<ScheduleSessionScreen> createState() => _ScheduleSessionScreenState();
}

class _ScheduleSessionScreenState extends State<ScheduleSessionScreen> {
  late DateTime _startTime;
  late int _duration;
  late SessionMode _mode;
  late final TextEditingController _locationController;
  late final TextEditingController _noteController;

  static const List<int> _durations = [30, 45, 60, 90, 120];
  static const List<String> _offlinePlaces = [
    'Thư viện tầng 3 · Bàn 12',
    'Thư viện tầng 2 · Phòng học nhóm 4',
    'Căng tin A · Khu ngoài trời',
    'Phòng học B2-201',
  ];

  SwapSession? get _existing {
    if (widget.request.sessions.isEmpty) return null;
    final active = widget.request.sessions
        .where((session) => session.status == SessionStatus.scheduled)
        .toList();
    return active.isEmpty ? null : active.first;
  }

  @override
  void initState() {
    super.initState();
    final existing = _existing;
    _duration = existing?.durationMinutes ?? 60;
    _startTime = existing?.startTime ?? _suggestedStart();
    _mode = existing?.mode ?? SessionMode.offline;
    _locationController = TextEditingController(
      text: existing?.location ??
          (_mode == SessionMode.online
              ? 'Google Meet · meet.google.com/skillswap'
              : _offlinePlaces.first),
    );
    _noteController = TextEditingController(text: existing?.note ?? '');
  }

  /// Gợi ý khung giờ trống gần nhất vào chiều mai để tránh trùng lịch có sẵn.
  DateTime _suggestedStart() {
    final state = AppScope.read(context);
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day + 1, 21);
    var candidate = DateTime(now.year, now.month, now.day + 1, 15);
    while (candidate.isBefore(endOfDay)) {
      final candidateEnd = candidate.add(Duration(minutes: _duration));
      final clashes = state.upcomingSessions.any((entry) {
        if (entry.request.id == widget.request.id) return false;
        return candidate.isBefore(entry.session.endTime) &&
            candidateEnd.isAfter(entry.session.startTime);
      });
      if (!clashes) return candidate;
      candidate = candidate.add(const Duration(minutes: 30));
    }
    return DateTime(now.year, now.month, now.day + 1, 15);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year, now.month, now.day + 60),
      helpText: 'Chọn ngày học',
      cancelText: 'Huỷ',
      confirmText: 'Chọn ngày',
    );
    if (picked != null) {
      setState(() {
        _startTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _startTime.hour,
          _startTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
      helpText: 'Chọn giờ bắt đầu',
      cancelText: 'Huỷ',
      confirmText: 'Chọn giờ',
    );
    if (picked != null) {
      setState(() {
        _startTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  bool _overlapsExisting() {
    final state = AppScope.read(context);
    final start = _startTime;
    final end = start.add(Duration(minutes: _duration));
    for (final entry in state.upcomingSessions) {
      if (entry.request.id == widget.request.id) continue;
      final otherStart = entry.session.startTime;
      final otherEnd = entry.session.endTime;
      if (start.isBefore(otherEnd) && end.isAfter(otherStart)) {
        return true;
      }
    }
    return false;
  }

  void _save() {
    final state = AppScope.read(context);
    final location = _locationController.text.trim();

    if (_startTime.isBefore(DateTime.now().add(const Duration(minutes: 15)))) {
      _showError('Chọn thời gian sau ít nhất 15 phút nữa nhé.');
      return;
    }
    if (location.isEmpty) {
      _showError('Nhập địa điểm hoặc link học trực tuyến.');
      return;
    }
    if (_overlapsExisting()) {
      _showError('Bạn đã có một buổi học khác trùng khung giờ này.');
      return;
    }

    state.scheduleSession(
      widget.request.id,
      startTime: _startTime,
      durationMinutes: _duration,
      location: location,
      mode: _mode,
      note: _noteController.text.trim(),
    );
    Navigator.of(context).pop(true);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.danger,
        ),
      );
  }

  void _changeMode(Set<SessionMode> modes) {
    final selected = modes.first;
    setState(() {
      _mode = selected;
      final current = _locationController.text.trim();
      if (selected == SessionMode.online &&
          !current.contains('meet') &&
          !current.contains('zoom')) {
        _locationController.text = 'Google Meet · meet.google.com/skillswap';
      } else if (selected == SessionMode.offline &&
          (current.contains('meet') || current.contains('zoom'))) {
        _locationController.text = _offlinePlaces.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final partner = state.userById(widget.request.otherUserId(me.id));
    final existing = _existing;
    final isReschedule = existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isReschedule ? 'Đổi lịch học' : 'Chọn lịch học'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  UserAvatar(user: partner, size: 46, showRing: true),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partner.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          partner.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isReschedule
                          ? 'Đổi lịch lần ${existing.rescheduleCount + 1}'
                          : 'Đã ghép đôi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _FormCard(
              title: 'Thời gian',
              icon: Icons.schedule_rounded,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _PickerTile(
                          label: 'Ngày học',
                          value: friendlyDay(_startTime, DateTime.now()),
                          icon: Icons.calendar_today_rounded,
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PickerTile(
                          label: 'Bắt đầu',
                          value: formatTime(_startTime),
                          icon: Icons.access_time_rounded,
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text(
                        'Thời lượng',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Kết thúc ${formatTime(_startTime.add(Duration(minutes: _duration)))}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: _durations.map((minutes) {
                      final selected = _duration == minutes;
                      return ChoiceChip(
                        label: Text(durationLabel(minutes)),
                        selected: selected,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _duration = minutes),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _FormCard(
              title: 'Hình thức & địa điểm',
              icon: Icons.place_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<SessionMode>(
                      segments: const [
                        ButtonSegment(
                          value: SessionMode.offline,
                          icon: Icon(Icons.location_on_outlined, size: 16),
                          label: Text('Trực tiếp'),
                        ),
                        ButtonSegment(
                          value: SessionMode.online,
                          icon: Icon(Icons.videocam_outlined, size: 16),
                          label: Text('Trực tuyến'),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: _changeMode,
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _locationController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: _mode == SessionMode.online
                          ? 'Link phòng học'
                          : 'Địa điểm',
                      prefixIcon: Icon(
                        _mode == SessionMode.online
                            ? Icons.link_rounded
                            : Icons.meeting_room_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  if (_mode == SessionMode.offline) ...[
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _offlinePlaces.map((place) {
                        return ActionChip(
                          label: Text(
                            place.split(' · ').first,
                            style: const TextStyle(fontSize: 10.5),
                          ),
                          onPressed: () {
                            setState(() {
                              _locationController.text = place;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _FormCard(
              title: 'Ghi chú cho buổi học',
              icon: Icons.edit_note_rounded,
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                maxLength: 180,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText:
                      'Ví dụ: mang laptop, chuẩn bị file thiết kế, học phần 1 về Java...',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            if (isReschedule) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 17,
                      color: Color(0xFFB45309),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Đổi lịch sẽ gửi thông báo mới cho đối phương (demo). '
                        'Lịch cũ vẫn được lưu trong lịch sử đổi lịch.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.45,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Lịch học sẽ xuất hiện trong tab Lịch hẹn của cả hai sinh viên.',
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.muted.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: FilledButton.icon(
            onPressed: _save,
            icon: Icon(
              isReschedule ? Icons.update_rounded : Icons.event_available_rounded,
              size: 19,
            ),
            label: Text(isReschedule ? 'Xác nhận đổi lịch' : 'Lưu lịch học'),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FormCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: AppColors.muted),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 17,
                  color: AppColors.muted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
