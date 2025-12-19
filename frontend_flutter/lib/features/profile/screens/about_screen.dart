import 'package:flutter/material.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.about,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Version
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Version ${AppConstants.appVersion}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'À propos de l\'application',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gestion de Présence est une application moderne et intuitive conçue pour faciliter la gestion des présences dans les établissements d\'enseignement.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Fonctionnalités principales:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _FeatureItem(
                      icon: Icons.check_circle,
                      text: 'Prise de présence rapide et efficace',
                    ),
                    _FeatureItem(
                      icon: Icons.analytics,
                      text: 'Rapports et statistiques détaillés',
                    ),
                    _FeatureItem(
                      icon: Icons.people,
                      text: 'Gestion des étudiants et professeurs',
                    ),
                    _FeatureItem(
                      icon: Icons.event,
                      text: 'Planification des séances',
                    ),
                    _FeatureItem(
                      icon: Icons.notifications,
                      text: 'Notifications en temps réel',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Technologies
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Technologies utilisées',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TechItem(
                      name: 'Flutter',
                      description: 'Framework de développement mobile',
                    ),
                    const Divider(),
                    _TechItem(
                      name: 'Material Design 3',
                      description: 'Système de design moderne',
                    ),
                    const Divider(),
                    _TechItem(name: 'Provider', description: 'Gestion d\'état'),
                    const Divider(),
                    _TechItem(
                      name: 'Go Router',
                      description: 'Navigation déclarative',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact & Support
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact et support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ContactItem(
                      icon: Icons.email,
                      title: 'Email',
                      value: 'support@presence.com',
                    ),
                    const SizedBox(height: 12),
                    _ContactItem(
                      icon: Icons.phone,
                      title: 'Téléphone',
                      value: '+212 5 22 00 00 00',
                    ),
                    const SizedBox(height: 12),
                    _ContactItem(
                      icon: Icons.language,
                      title: 'Site web',
                      value: 'www.presence.com',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Legal
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: AppColors.primary,
                    ),
                    title: const Text('Conditions d\'utilisation'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip,
                      color: AppColors.primary,
                    ),
                    title: const Text('Politique de confidentialité'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.gavel, color: AppColors.primary),
                    title: const Text('Mentions légales'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Copyright
            const Text(
              '© 2024 Gestion de Présence',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tous droits réservés',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechItem extends StatelessWidget {
  final String name;
  final String description;

  const _TechItem({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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
