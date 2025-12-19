import '../models/student.dart';

class StudentService {
  // Mock students database
  static final List<Student> _mockStudents = [
    Student(
      id: '1',
      firstName: 'Ahmed',
      lastName: 'Bennani',
      cne: 'R123456789',
      email: 'ahmed.bennani@student.com',
      phone: '+212 6 12 34 56 78',
      group: 'Groupe A',
    ),
    Student(
      id: '2',
      firstName: 'Fatima',
      lastName: 'Alami',
      cne: 'R987654321',
      email: 'fatima.alami@student.com',
      phone: '+212 6 23 45 67 89',
      group: 'Groupe A',
    ),
    Student(
      id: '3',
      firstName: 'Mohammed',
      lastName: 'Idrissi',
      cne: 'R456789123',
      email: 'mohammed.idrissi@student.com',
      phone: '+212 6 34 56 78 90',
      group: 'Groupe B',
    ),
    Student(
      id: '4',
      firstName: 'Salma',
      lastName: 'Tazi',
      cne: 'R321654987',
      email: 'salma.tazi@student.com',
      phone: '+212 6 45 67 89 01',
      group: 'Groupe A',
    ),
    Student(
      id: '5',
      firstName: 'Youssef',
      lastName: 'Benjelloun',
      cne: 'R147258369',
      email: 'youssef.benjelloun@student.com',
      phone: '+212 6 56 78 90 12',
      group: 'Groupe B',
    ),
    Student(
      id: '6',
      firstName: 'Amina',
      lastName: 'Chakir',
      cne: 'R963852741',
      email: 'amina.chakir@student.com',
      phone: '+212 6 67 89 01 23',
      group: 'Groupe C',
    ),
    Student(
      id: '7',
      firstName: 'Karim',
      lastName: 'Fassi',
      cne: 'R258369147',
      email: 'karim.fassi@student.com',
      phone: '+212 6 78 90 12 34',
      group: 'Groupe A',
    ),
    Student(
      id: '8',
      firstName: 'Nadia',
      lastName: 'Lahlou',
      cne: 'R741852963',
      email: 'nadia.lahlou@student.com',
      phone: '+212 6 89 01 23 45',
      group: 'Groupe B',
    ),
    Student(
      id: '9',
      firstName: 'Omar',
      lastName: 'Berrada',
      cne: 'R369147258',
      email: 'omar.berrada@student.com',
      phone: '+212 6 90 12 34 56',
      group: 'Groupe C',
    ),
    Student(
      id: '10',
      firstName: 'Zineb',
      lastName: 'Kettani',
      cne: 'R852963741',
      email: 'zineb.kettani@student.com',
      phone: '+212 6 01 23 45 67',
      group: 'Groupe A',
    ),
  ];

  // Get all students
  Future<List<Student>> getAllStudents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockStudents);
  }

  // Get student by ID
  Future<Student?> getStudentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockStudents.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search students
  Future<List<Student>> searchStudents(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (query.isEmpty) {
      return List.from(_mockStudents);
    }

    final lowerQuery = query.toLowerCase();
    return _mockStudents.where((student) {
      return student.firstName.toLowerCase().contains(lowerQuery) ||
          student.lastName.toLowerCase().contains(lowerQuery) ||
          student.cne.toLowerCase().contains(lowerQuery) ||
          student.email.toLowerCase().contains(lowerQuery) ||
          student.group.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter students by group
  Future<List<Student>> getStudentsByGroup(String group) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockStudents.where((student) => student.group == group).toList();
  }

  // Get all groups
  Future<List<String>> getAllGroups() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Groupe A', 'Groupe B', 'Groupe C'];
  }

  // Add student
  Future<Student> addStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockStudents.add(student);
    return student;
  }

  // Update student
  Future<Student> updateStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockStudents.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _mockStudents[index] = student;
    }
    return student;
  }

  // Delete student
  Future<bool> deleteStudent(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockStudents.removeWhere((student) => student.id == id);
    return true;
  }

  // Get student count
  Future<int> getStudentCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockStudents.length;
  }
}
