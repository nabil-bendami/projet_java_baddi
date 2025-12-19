import '../models/session.dart';

class SessionService {
  // Mock sessions database
  static final List<Session> _mockSessions = [
    Session(
      id: '1',
      module: 'Programmation Web',
      professorId: '2',
      professorName: 'Prof. Mohammed Alami',
      group: 'Groupe A',
      date: DateTime.now(),
      startTime: '08:00',
      endTime: '10:00',
      room: 'Salle 101',
      duration: 120,
      description: 'Introduction à React et développement frontend',
    ),
    Session(
      id: '2',
      module: 'Base de données',
      professorId: '2',
      professorName: 'Prof. Fatima Zahra',
      group: 'Groupe B',
      date: DateTime.now(),
      startTime: '10:30',
      endTime: '12:30',
      room: 'Salle 203',
      duration: 120,
      description: 'SQL avancé et optimisation des requêtes',
    ),
    Session(
      id: '3',
      module: 'Réseaux informatiques',
      professorId: '2',
      professorName: 'Prof. Karim Benjelloun',
      group: 'Groupe C',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '14:00',
      endTime: '16:00',
      room: 'Salle 305',
      duration: 120,
      description: 'Protocoles TCP/IP et architecture réseau',
    ),
    Session(
      id: '4',
      module: 'Systèmes d\'exploitation',
      professorId: '2',
      professorName: 'Prof. Mohammed Alami',
      group: 'Groupe A',
      date: DateTime.now().subtract(const Duration(days: 1)),
      startTime: '08:00',
      endTime: '10:00',
      room: 'Salle 102',
      duration: 120,
      description: 'Gestion de la mémoire et processus',
    ),
    Session(
      id: '5',
      module: 'Programmation Web',
      professorId: '2',
      professorName: 'Prof. Mohammed Alami',
      group: 'Groupe B',
      date: DateTime.now().subtract(const Duration(days: 2)),
      startTime: '10:30',
      endTime: '12:30',
      room: 'Salle 101',
      duration: 120,
      description: 'Node.js et développement backend',
    ),
    Session(
      id: '6',
      module: 'Algorithmes et structures de données',
      professorId: '2',
      professorName: 'Prof. Fatima Zahra',
      group: 'Groupe A',
      date: DateTime.now().add(const Duration(days: 2)),
      startTime: '14:00',
      endTime: '16:00',
      room: 'Salle 201',
      duration: 120,
      description: 'Arbres binaires et graphes',
    ),
    Session(
      id: '7',
      module: 'Sécurité informatique',
      professorId: '2',
      professorName: 'Prof. Karim Benjelloun',
      group: 'Groupe B',
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: '08:00',
      endTime: '10:00',
      room: 'Salle 304',
      duration: 120,
      description: 'Cryptographie et sécurité des réseaux',
    ),
    Session(
      id: '8',
      module: 'Intelligence Artificielle',
      professorId: '2',
      professorName: 'Prof. Mohammed Alami',
      group: 'Groupe C',
      date: DateTime.now().add(const Duration(days: 4)),
      startTime: '10:30',
      endTime: '12:30',
      room: 'Salle 401',
      duration: 120,
      description: 'Machine Learning et réseaux de neurones',
    ),
  ];

  // Get all sessions
  Future<List<Session>> getAllSessions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockSessions)..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get session by ID
  Future<Session?> getSessionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockSessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get today's sessions
  Future<List<Session>> getTodaySessions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return _mockSessions.where((session) {
      return session.date.year == now.year &&
          session.date.month == now.month &&
          session.date.day == now.day;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  // Get upcoming sessions
  Future<List<Session>> getUpcomingSessions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return _mockSessions.where((session) {
      return session.date.isAfter(now);
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get past sessions
  Future<List<Session>> getPastSessions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return _mockSessions.where((session) {
      return session.date.isBefore(now);
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get sessions by group
  Future<List<Session>> getSessionsByGroup(String group) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockSessions.where((session) => session.group == group).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get sessions by professor
  Future<List<Session>> getSessionsByProfessor(String professorId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockSessions
        .where((session) => session.professorId == professorId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get sessions by module
  Future<List<Session>> getSessionsByModule(String module) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockSessions.where((session) => session.module == module).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Search sessions
  Future<List<Session>> searchSessions(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (query.isEmpty) {
      return List.from(_mockSessions)..sort((a, b) => b.date.compareTo(a.date));
    }

    final lowerQuery = query.toLowerCase();
    return _mockSessions.where((session) {
      return session.module.toLowerCase().contains(lowerQuery) ||
          session.professorName.toLowerCase().contains(lowerQuery) ||
          session.group.toLowerCase().contains(lowerQuery) ||
          session.room.toLowerCase().contains(lowerQuery);
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Filter sessions by date range
  Future<List<Session>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockSessions.where((session) {
      return session.date.isAfter(start.subtract(const Duration(days: 1))) &&
          session.date.isBefore(end.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Add session
  Future<Session> addSession(Session session) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockSessions.add(session);
    return session;
  }

  // Update session
  Future<Session> updateSession(Session session) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockSessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _mockSessions[index] = session;
    }
    return session;
  }

  // Delete session
  Future<bool> deleteSession(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockSessions.removeWhere((session) => session.id == id);
    return true;
  }

  // Get session count
  Future<int> getSessionCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockSessions.length;
  }

  // Get all modules
  Future<List<String>> getAllModules() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockSessions.map((s) => s.module).toSet().toList()..sort();
  }

  // Get all groups
  Future<List<String>> getAllGroups() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockSessions.map((s) => s.group).toSet().toList()..sort();
  }
}
