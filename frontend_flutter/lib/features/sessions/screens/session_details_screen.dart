import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/session.dart';
import '../../../data/models/attendance_record.dart';
import '../../../data/services/session_service.dart';

class SessionDetailsScreen extends StatefulWidget {
  final String sessionId;

  const SessionDetailsScreen({super.key, required this.sessionId});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  final SessionService _sessionService = SessionService();
  Session? _session;
  bool _isLoading = true;

  // Mock attendance data
  final List<Map<String, dynamic>> _mockAttendance = [
    {
      'studentId': '1',
      'studentName': 'Ahmed Bennani',
      'cne': 'R123456789',
      'status': AttendanceStatus.present,
    },
    {
      'studentId': '2',
      'studentName': 'Fatima Alami',
      'cne': 'R987654321',
      'status': AttendanceStatus.present,
    },
    {
      'studentId': '3',
      'studentName': 'Mohammed Idrissi',
      'cne': 'R456789123',
      'status': AttendanceStatus.late,
    },
    {
      'studentId': '4',
      'studentName': 'Salma Tazi',
      'cne': 'R321654987',
      'status': AttendanceStatus.absent,
    },
    {
      'studentId': '5',
      'studentName': 'Youssef Benjelloun',
      'cne': 'R147258369',
      'status': AttendanceStatus.present,
    },
    {
      'studentId': '6',
      'studentName': 'Amina Chakir',
      'cne': 'R963852741',
      'status': AttendanceStatus.present,
    },
    {
      'studentId': '7',
      'studentName': 'Karim Fassi',
      'cne': 'R258369147',
      'status': AttendanceStatus.present,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    setState(() => _isLoading = true);

    try {
      final session = await _sessionService.getSessionById(widget.sessionId);

      setState(() {
        _session = session;
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
      title: AppConstants.sessionDetails,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _session == null
          ? const Center(child: Text('Séance non trouvée'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Module
                          Text(
                            _session!.module,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),

                          // Professor
                          _InfoRow(
                            icon: Icons.person,
                            label: 'Professeur',
                            value: _session!.professorName,
                          ),
                          const SizedBox(height: 12),

                          // Date
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: AppConstants.date,
                            value: DateFormat(
                              'EEEE d MMMM yyyy',
                              'fr_FR',
                            ).format(_session!.date),
                          ),
                          const SizedBox(height: 12),

                          // Time
                          _InfoRow(
                            icon: Icons.access_time,
                            label: AppConstants.time,
                            value:
                                '${_session!.startTime} - ${_session!.endTime}',
                          ),
                          const SizedBox(height: 12),

                          // Duration
                          _InfoRow(
                            icon: Icons.timer,
                            label: AppConstants.duration,
                            value: '${_session!.duration} minutes',
                          ),
                          const SizedBox(height: 12),

                          // Room
                          _InfoRow(
                            icon: Icons.room,
                            label: AppConstants.room,
                            value: _session!.room,
                          ),
                          const SizedBox(height: 12),

                          // Group
                          _InfoRow(
                            icon: Icons.group,
                            label: AppConstants.group,
                            value: _session!.group,
                          ),

                          if (_session!.description != null) ...[
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _session!.description!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendance Summary
                  Text(
                    'Résumé de présence',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Taux de présence',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${_presenceRate.toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: _presenceRate >= 75
                                                ? AppColors.success
                                                : AppColors.warning,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: _presenceRate / 100,
                                        minHeight: 8,
                                        backgroundColor:
                                            AppColors.surfaceVariant,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              _presenceRate >= 75
                                                  ? AppColors.success
                                                  : AppColors.warning,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                              _StatItem(
                                label: AppConstants.total,
                                value: _mockAttendance.length.toString(),
                                color: AppColors.info,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendance List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Liste de présence',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${_mockAttendance.length} étudiants',
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
                      return _AttendanceListItem(
                        studentName: record['studentName'],
                        cne: record['cne'],
                        status: record['status'],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  if (_session!.isToday || _session!.isFuture)
                    PrimaryButton(
                      text: 'Modifier la présence',
                      icon: Icons.edit,
                      onPressed: () {
                        context.push('/attendance/${widget.sessionId}');
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
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _AttendanceListItem extends StatelessWidget {
  final String studentName;
  final String cne;
  final AttendanceStatus status;

  const _AttendanceListItem({
    required this.studentName,
    required this.cne,
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

  IconData get _statusIcon {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.late:
        return Icons.access_time;
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
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: _statusColor.withOpacity(0.1),
              child: Icon(_statusIcon, color: _statusColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cne,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge
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
