import '../models/user.dart';

class AuthService {
  // Mock users database
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'Admin User',
      'email': 'admin@presence.com',
      'password': 'admin123',
      'role': 'admin',
      'phone': '+212 6 12 34 56 78',
    },
    {
      'id': '2',
      'name': 'Prof. Mohammed Alami',
      'email': 'prof@presence.com',
      'password': 'prof123',
      'role': 'professor',
      'phone': '+212 6 23 45 67 89',
    },
    {
      'id': '3',
      'name': 'Ahmed Bennani',
      'email': 'student@presence.com',
      'password': 'student123',
      'role': 'student',
      'phone': '+212 6 34 56 78 90',
    },
  ];

  // Mock login with delay
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      final userData = _mockUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );

      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // Mock logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Mock password reset
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    // Check if email exists
    try {
      _mockUsers.firstWhere((user) => user['email'] == email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user by ID
  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final userData = _mockUsers.firstWhere((user) => user['id'] == id);
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<User?> updateProfile(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }
}
