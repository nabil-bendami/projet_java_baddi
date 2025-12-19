import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/session.dart';
import '../../../data/models/student.dart';
import '../../../data/models/attendance_record.dart';
import '../../../data/services/session_service.dart';
import '../../../data/services/student_service.dart';
import '../../../data/services/attendance_service.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final String sessionId;

  const TakeAttendanceScreen({super.key, required this.sessionId});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final SessionService _sessionService = SessionService();
  final StudentService _studentService = StudentService();
  final AttendanceService _attendanceService = AttendanceService();

  Session? _session;
  List<Student> _students = [];
  Map<String, AttendanceStatus> _attendanceMap = {};
  Map<String, String> _remarksMap = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final session = await _sessionService.getSessionById(widget.sessionId);
      if (session == null) {
        throw Exception('Session not found');
      }

      final students = await _studentService.getStudentsByGroup(session.group);

      // Initialize attendance map with default status
      final attendanceMap = <String, AttendanceStatus>{};
      for (var student in students) {
        attendanceMap[student.id] = AttendanceStatus.present;
      }

      setState(() {
        _session = session;
        _students = students;
        _attendanceMap = attendanceMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _saveAttendance() async {
    setState(() => _isSaving = true);

    try {
      final attendanceData = _students.map((student) {
        return {
          'studentId': student.id,
          'studentName': student.fullName,
          'status': _attendanceMap[student.id] ?? AttendanceStatus.present,
          'remarks': _remarksMap[student.id],
        };
      }).toList();

      await _attendanceService.markAttendance(widget.sessionId, attendanceData);

      setState(() => _isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Présence enregistrée avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _markAll(AttendanceStatus status) {
    setState(() {
      for (var student in _students) {
        _attendanceMap[student.id] = status;
      }
    });
  }

  int get _presentCount =>
      _attendanceMap.values.where((s) => s == AttendanceStatus.present).length;

  int get _absentCount =>
      _attendanceMap.values.where((s) => s == AttendanceStatus.absent).length;

  int get _lateCount =>
      _attendanceMap.values.where((s) => s == AttendanceStatus.late).length;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.takeAttendance,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Session Info Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _session!.module,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.group,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _session!.group,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_session!.startTime} - ${_session!.endTime}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Quick Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _markAll(AttendanceStatus.present),
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: const Text('Tous présents'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.success,
                            side: const BorderSide(color: AppColors.success),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _markAll(AttendanceStatus.absent),
                          icon: const Icon(Icons.cancel, size: 18),
                          label: const Text('Tous absents'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: AppColors.surfaceVariant.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        label: AppConstants.present,
                        value: _presentCount,
                        color: AppColors.success,
                      ),
                      _StatChip(
                        label: AppConstants.absent,
                        value: _absentCount,
                        color: AppColors.error,
                      ),
                      _StatChip(
                        label: AppConstants.late,
                        value: _lateCount,
                        color: AppColors.warning,
                      ),
                      _StatChip(
                        label: AppConstants.total,
                        value: _students.length,
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),

                // Students List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      final status =
                          _attendanceMap[student.id] ??
                          AttendanceStatus.present;

                      return _AttendanceItem(
                        student: student,
                        status: status,
                        onStatusChanged: (newStatus) {
                          setState(() {
                            _attendanceMap[student.id] = newStatus;
                          });
                        },
                        onRemarksChanged: (remarks) {
                          _remarksMap[student.id] = remarks;
                        },
                      );
                    },
                  ),
                ),

                // Save Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    text: AppConstants.save,
                    icon: Icons.save,
                    onPressed: _saveAttendance,
                    isLoading: _isSaving,
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _AttendanceItem extends StatelessWidget {
  final Student student;
  final AttendanceStatus status;
  final Function(AttendanceStatus) onStatusChanged;
  final Function(String) onRemarksChanged;

  const _AttendanceItem({
    required this.student,
    required this.status,
    required this.onStatusChanged,
    required this.onRemarksChanged,
  });

  Color get _statusColor {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.late:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _statusColor.withOpacity(0.1),
                  child: Text(
                    '${student.firstName[0]}${student.lastName[0]}'
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Student Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.fullName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        student.cne,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Buttons
            Row(
              children: [
                Expanded(
                  child: _StatusButton(
                    label: AppConstants.present,
                    icon: Icons.check_circle,
                    color: AppColors.success,
                    isSelected: status == AttendanceStatus.present,
                    onTap: () => onStatusChanged(AttendanceStatus.present),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusButton(
                    label: AppConstants.absent,
                    icon: Icons.cancel,
                    color: AppColors.error,
                    isSelected: status == AttendanceStatus.absent,
                    onTap: () => onStatusChanged(AttendanceStatus.absent),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusButton(
                    label: AppConstants.late,
                    icon: Icons.access_time,
                    color: AppColors.warning,
                    isSelected: status == AttendanceStatus.late,
                    onTap: () => onStatusChanged(AttendanceStatus.late),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
