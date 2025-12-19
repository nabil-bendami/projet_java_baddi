import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../data/models/user.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final bool showDrawer;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: showDrawer ? const AppDrawer() : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Drawer(
        child: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Dashboard
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(AppConstants.dashboard),
            onTap: () {
              Navigator.pop(context);
              switch (user.role) {
                case UserRole.admin:
                  context.go('/admin');
                  break;
                case UserRole.professor:
                  context.go('/prof');
                  break;
                case UserRole.student:
                  context.go('/student');
                  break;
              }
            },
          ),

          // Admin Menu Items
          if (user.role == UserRole.admin) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text(AppConstants.students),
              onTap: () {
                Navigator.pop(context);
                context.go('/students');
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text(AppConstants.sessions),
              onTap: () {
                Navigator.pop(context);
                context.go('/sessions');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text(AppConstants.reports),
              onTap: () {
                Navigator.pop(context);
                context.go('/reports');
              },
            ),
          ],

          // Professor Menu Items
          if (user.role == UserRole.professor) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text(AppConstants.sessions),
              onTap: () {
                Navigator.pop(context);
                context.go('/sessions');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text(AppConstants.students),
              onTap: () {
                Navigator.pop(context);
                context.go('/students');
              },
            ),
          ],

          // Student Menu Items
          if (user.role == UserRole.student) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text(AppConstants.sessions),
              onTap: () {
                Navigator.pop(context);
                context.go('/sessions');
              },
            ),
          ],

          // Common Menu Items
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(AppConstants.profile),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppConstants.settings),
            onTap: () {
              Navigator.pop(context);
              context.go('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(AppConstants.about),
            onTap: () {
              Navigator.pop(context);
              context.go('/about');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              AppConstants.logout,
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              Navigator.pop(context);
              authProvider.logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
