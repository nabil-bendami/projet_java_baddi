import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppConstants.welcome}, Admin',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tableau de bord administrateur',
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

            // Statistics Cards
            Text(
              AppConstants.statistics,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                InfoCard(
                  title: AppConstants.students,
                  value: '245',
                  icon: Icons.people,
                  color: AppColors.studentColor,
                  onTap: () => context.push('/students'),
                ),
                InfoCard(
                  title: AppConstants.professors,
                  value: '18',
                  icon: Icons.school,
                  color: AppColors.profColor,
                  onTap: () {},
                ),
                InfoCard(
                  title: AppConstants.classes,
                  value: '12',
                  icon: Icons.class_,
                  color: AppColors.warning,
                  onTap: () {},
                ),
                InfoCard(
                  title: AppConstants.sessions,
                  value: '156',
                  icon: Icons.event,
                  color: AppColors.info,
                  onTap: () => context.push('/sessions'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              AppConstants.quickActions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _QuickActionCard(
              title: 'Créer une séance',
              subtitle: 'Planifier une nouvelle séance de cours',
              icon: Icons.add_circle_outline,
              color: AppColors.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            const SizedBox(height: 12),

            _QuickActionCard(
              title: AppConstants.viewAttendance,
              subtitle: 'Consulter les présences récentes',
              icon: Icons.check_circle_outline,
              color: AppColors.success,
              onTap: () => context.push('/sessions'),
            ),
            const SizedBox(height: 12),

            _QuickActionCard(
              title: AppConstants.manageStudents,
              subtitle: 'Gérer la liste des étudiants',
              icon: Icons.people_outline,
              color: AppColors.info,
              onTap: () => context.push('/students'),
            ),
            const SizedBox(height: 12),

            _QuickActionCard(
              title: AppConstants.viewReports,
              subtitle: 'Voir les rapports et statistiques',
              icon: Icons.assessment_outlined,
              color: AppColors.warning,
              onTap: () => context.push('/reports'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
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
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
