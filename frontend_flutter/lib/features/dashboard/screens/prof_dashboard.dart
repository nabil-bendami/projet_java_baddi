import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';

class ProfDashboard extends StatelessWidget {
  const ProfDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.dashboard,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.profColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 32,
                        color: AppColors.profColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppConstants.welcome}, Professeur',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'EEEE d MMMM yyyy',
                              'fr_FR',
                            ).format(DateTime.now()),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Séances aujourd\'hui',
                    value: '3',
                    icon: Icons.event_note,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoCard(
                    title: 'Étudiants',
                    value: '87',
                    icon: Icons.people,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's Sessions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppConstants.todaySessions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => context.push('/sessions'),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _SessionCard(
              module: 'Programmation Web',
              group: 'Groupe A',
              time: '08:00 - 10:00',
              room: 'Salle 101',
              status: 'En cours',
              statusColor: AppColors.success,
              onTap: () {
                // Navigate to session details or start attendance
                context.push('/attendance/session1');
              },
            ),
            const SizedBox(height: 12),

            _SessionCard(
              module: 'Base de données',
              group: 'Groupe B',
              time: '10:30 - 12:30',
              room: 'Salle 203',
              status: 'À venir',
              statusColor: AppColors.warning,
              onTap: () {},
            ),
            const SizedBox(height: 12),

            _SessionCard(
              module: 'Réseaux informatiques',
              group: 'Groupe C',
              time: '14:00 - 16:00',
              room: 'Salle 305',
              status: 'À venir',
              statusColor: AppColors.info,
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Quick Action Button
            PrimaryButton(
              text: AppConstants.startAttendance,
              icon: Icons.check_circle_outline,
              onPressed: () {
                context.push('/attendance/session1');
              },
            ),
            const SizedBox(height: 16),

            // Recent Attendance
            Text(
              'Présences récentes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            _AttendanceHistoryCard(
              module: 'Programmation Web',
              date: 'Hier, 08:00',
              present: 28,
              absent: 2,
              late: 1,
              onTap: () => context.push('/sessions/1'),
            ),
            const SizedBox(height: 12),

            _AttendanceHistoryCard(
              module: 'Base de données',
              date: 'Lundi, 10:30',
              present: 25,
              absent: 4,
              late: 2,
              onTap: () => context.push('/sessions/2'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String module;
  final String group;
  final String time;
  final String room;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _SessionCard({
    required this.module,
    required this.group,
    required this.time,
    required this.room,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      module,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.group, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    group,
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
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.room, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    room,
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
      ),
    );
  }
}

class _AttendanceHistoryCard extends StatelessWidget {
  final String module;
  final String date;
  final int present;
  final int absent;
  final int late;
  final VoidCallback onTap;

  const _AttendanceHistoryCard({
    required this.module,
    required this.date,
    required this.present,
    required this.absent,
    required this.late,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = present + absent + late;
    final presenceRate = ((present / total) * 100).toStringAsFixed(0);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      module,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '$presenceRate%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: double.parse(presenceRate) >= 75
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _AttendanceChip(
                    label: 'Présents',
                    value: present.toString(),
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 8),
                  _AttendanceChip(
                    label: 'Absents',
                    value: absent.toString(),
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  _AttendanceChip(
                    label: 'Retards',
                    value: late.toString(),
                    color: AppColors.warning,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AttendanceChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
