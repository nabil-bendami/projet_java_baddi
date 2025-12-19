import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/dashboard/screens/admin_dashboard.dart';
import '../features/dashboard/screens/prof_dashboard.dart';
import '../features/dashboard/screens/student_dashboard.dart';
import '../features/students/screens/students_list_screen.dart';
import '../features/students/screens/student_details_screen.dart';
import '../features/sessions/screens/sessions_list_screen.dart';
import '../features/sessions/screens/session_details_screen.dart';
import '../features/attendance/screens/take_attendance_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/profile/screens/about_screen.dart';
import '../data/models/user.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isOnSplash = state.matchedLocation == '/splash';
        final isOnLogin = state.matchedLocation == '/login';
        final isOnForgotPassword = state.matchedLocation == '/forgot-password';

        // Allow splash screen
        if (isOnSplash) {
          return null;
        }

        // If not logged in, redirect to login (except for forgot password)
        if (!isLoggedIn && !isOnLogin && !isOnForgotPassword) {
          return '/login';
        }

        // If logged in and on login page, redirect to appropriate dashboard
        if (isLoggedIn && (isOnLogin || isOnSplash)) {
          final user = authProvider.currentUser;
          if (user != null) {
            switch (user.role) {
              case UserRole.admin:
                return '/admin';
              case UserRole.professor:
                return '/prof';
              case UserRole.student:
                return '/student';
            }
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Admin Routes
        GoRoute(
          path: '/admin',
          name: 'admin-dashboard',
          builder: (context, state) => const AdminDashboard(),
        ),

        // Professor Routes
        GoRoute(
          path: '/prof',
          name: 'prof-dashboard',
          builder: (context, state) => const ProfDashboard(),
        ),

        // Student Routes
        GoRoute(
          path: '/student',
          name: 'student-dashboard',
          builder: (context, state) => const StudentDashboard(),
        ),

        // Students Management
        GoRoute(
          path: '/students',
          name: 'students-list',
          builder: (context, state) => const StudentsListScreen(),
        ),
        GoRoute(
          path: '/students/:id',
          name: 'student-details',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return StudentDetailsScreen(studentId: id);
          },
        ),

        // Sessions Management
        GoRoute(
          path: '/sessions',
          name: 'sessions-list',
          builder: (context, state) => const SessionsListScreen(),
        ),
        GoRoute(
          path: '/sessions/:id',
          name: 'session-details',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return SessionDetailsScreen(sessionId: id);
          },
        ),

        // Attendance
        GoRoute(
          path: '/attendance/:sessionId',
          name: 'take-attendance',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            return TakeAttendanceScreen(sessionId: sessionId);
          },
        ),

        // Reports
        GoRoute(
          path: '/reports',
          name: 'reports',
          builder: (context, state) => const ReportsScreen(),
        ),

        // Profile & Settings
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
      ],
    );
  }
}
