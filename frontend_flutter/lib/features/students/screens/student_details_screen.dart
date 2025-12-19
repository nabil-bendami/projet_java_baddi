import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/student.dart';
import '../../../data/models/attendance_record.dart';
import '../../../data/services/student_service.dart';

class StudentDetailsScreen extends StatefulWidget {
  final String studentId;

  const StudentDetailsScreen({super.key, required this.studentId});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final StudentService _studentService = StudentService();
  Student? _student;
  bool _isLoading = true;

  // Mock attendance data
  final List<Map<String, dynamic>> _mockAttendance = [
    {
      'module': 'Programmation Web',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': AttendanceStatus.present,
    },
    {
      'module': 'Base de données',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': AttendanceStatus.present,
    },
    {
      'module': 'Réseaux informatiques',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': AttendanceStatus.late,
    },
    {
      'module': 'Systèmes d\'exploitation',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'status': AttendanceStatus.absent,
    },
    {
      'module': 'Programmation Web',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'status': AttendanceStatus.present,
    },
    {
      'module': 'Base de données',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'status': AttendanceStatus.present,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    setState(() => _isLoading = true);

    try {
      final student = await _studentService.getStudentById(widget.studentId);

      setState(() {
        _student = student;
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

  int get _presentCount => _mockAttendance
      .where((a) => a['status'] == AttendanceStatus.present)
      .length;

  int get _absentCount => _mockAttendance
      .where((a) => a['status'] == AttendanceStatus.absent)
      .length;

  int get _lateCount =>
      _mockAttendance.where((a) => a['status'] == AttendanceStatus.late).length;

  double get _presenceRate => (_presentCount / _mockAttendance.length) * 100;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.studentDetails,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _student == null
          ? const Center(child: Text('Étudiant non trouvé'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              '${_student!.firstName[0]}${_student!.lastName[0]}'
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Name
                          Text(
                            _student!.fullName,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // CNE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _student!.cne,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Contact Info
                          _InfoRow(
                            icon: Icons.email,
                            label: AppConstants.email,
                            value: _student!.email,
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.phone,
                            label: AppConstants.phone,
                            value: _student!.phone ?? 'Non renseigné',
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.group,
                            label: AppConstants.group,
                            value: _student!.group,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendance Summary
                  Text(
                    AppConstants.attendanceSummary,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Circular Progress
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    value: _presenceRate / 100,
                                    strokeWidth: 10,
                                    backgroundColor: AppColors.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _presenceRate >= 75
                                          ? AppColors.success
                                          : _presenceRate >= 50
                                          ? AppColors.warning
                                          : AppColors.error,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_presenceRate.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _presenceRate >= 75
                                            ? AppColors.success
                                            : _presenceRate >= 50
                                            ? AppColors.warning
                                            : AppColors.error,
                                      ),
                                    ),
                                    const Text(
                                      'Présence',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(
                                label: AppConstants.present,
                                value: _presentCount.toString(),
                                color: AppColors.success,
                              ),
                              _StatItem(
                                label: AppConstants.absent,
                                value: _absentCount.toString(),
                                color: AppColors.error,
                              ),
                              _StatItem(
                                label: AppConstants.late,
                                value: _lateCount.toString(),
                                color: AppColors.warning,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendance History
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstants.attendanceHistory,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${_mockAttendance.length} séances',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mockAttendance.length,
                    itemBuilder: (context, index) {
                      final record = _mockAttendance[index];
                      return _AttendanceHistoryItem(
                        module: record['module'],
                        date: record['date'],
                        status: record['status'],
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _AttendanceHistoryItem extends StatelessWidget {
  final String module;
  final DateTime date;
  final AttendanceStatus status;

  const _AttendanceHistoryItem({
    required this.module,
    required this.date,
    required this.status,
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

  String get _statusLabel {
    switch (status) {
      case AttendanceStatus.present:
        return AppConstants.present;
      case AttendanceStatus.absent:
        return AppConstants.absent;
      case AttendanceStatus.late:
        return AppConstants.late;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 40,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE d MMMM yyyy, HH:mm', 'fr_FR').format(date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
