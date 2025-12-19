import 'package:flutter/material.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _darkMode = false;
  String _language = 'Français';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppConstants.settings,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications Section
          Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Activer les notifications'),
                  subtitle: const Text(
                    'Recevoir des notifications de l\'application',
                  ),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                  secondary: const Icon(
                    Icons.notifications,
                    color: AppColors.primary,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Notifications par email'),
                  subtitle: const Text(
                    'Recevoir des emails pour les événements importants',
                  ),
                  value: _emailNotifications,
                  onChanged: _notificationsEnabled
                      ? (value) {
                          setState(() => _emailNotifications = value);
                        }
                      : null,
                  secondary: const Icon(Icons.email, color: AppColors.primary),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Notifications push'),
                  subtitle: const Text(
                    'Recevoir des notifications push sur votre appareil',
                  ),
                  value: _pushNotifications,
                  onChanged: _notificationsEnabled
                      ? (value) {
                          setState(() => _pushNotifications = value);
                        }
                      : null,
                  secondary: const Icon(
                    Icons.phone_android,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance Section
          Text('Apparence', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Mode sombre'),
                  subtitle: const Text('Utiliser le thème sombre'),
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() => _darkMode = value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir'),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                  secondary: const Icon(
                    Icons.dark_mode,
                    color: AppColors.primary,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: const Text('Langue'),
                  subtitle: Text(_language),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Privacy & Security Section
          Text(
            'Confidentialité et sécurité',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock, color: AppColors.primary),
                  title: const Text('Changer le mot de passe'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fonctionnalité à venir')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security, color: AppColors.primary),
                  title: const Text('Authentification à deux facteurs'),
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
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data & Storage Section
          Text(
            'Données et stockage',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download, color: AppColors.primary),
                  title: const Text('Télécharger mes données'),
                  subtitle: const Text('Exporter toutes vos données'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export en cours...'),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Effacer le cache',
                    style: TextStyle(color: AppColors.error),
                  ),
                  subtitle: const Text('Libérer de l\'espace de stockage'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showClearCacheDialog();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          Text('À propos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info, color: AppColors.primary),
                  title: const Text('Version de l\'application'),
                  subtitle: Text(AppConstants.appVersion),
                ),
                const Divider(height: 1),
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
                  leading: const Icon(Icons.help, color: AppColors.primary),
                  title: const Text('Aide et support'),
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
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'Français',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'العربية',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer le cache'),
        content: const Text(
          'Êtes-vous sûr de vouloir effacer le cache? Cette action ne peut pas être annulée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache effacé avec succès'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Effacer',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
