import '../models/attendance_record.dart';
import '../models/student.dart';

class AttendanceService {
  // Mock attendance records database
  static final List<AttendanceRecord> _mockAttendanceRecords = [];

  // Get attendance records for a session
  Future<List<AttendanceRecord>> getAttendanceBySession(
    String sessionId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAttendanceRecords
        .where((record) => record.sessionId == sessionId)
        .toList();
  }

  // Get attendance records for a student
  Future<List<AttendanceRecord>> getAttendanceByStudent(
    String studentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAttendanceRecords
        .where((record) => record.studentId == studentId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Mark attendance for a session
  Future<List<AttendanceRecord>> markAttendance(
    String sessionId,
    List<Map<String, dynamic>> attendanceData,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Remove existing records for this session
    _mockAttendanceRecords.removeWhere(
      (record) => record.sessionId == sessionId,
    );

    // Add new records
    final records = <AttendanceRecord>[];
    for (var data in attendanceData) {
      final record = AttendanceRecord(
        id: '${sessionId}_${data['studentId']}_${DateTime.now().millisecondsSinceEpoch}',
        sessionId: sessionId,
        studentId: data['studentId'],
        studentName: data['studentName'],
        status: data['status'],
        timestamp: DateTime.now(),
        remarks: data['remarks'],
      );
      _mockAttendanceRecords.add(record);
      records.add(record);
    }

    return records;
  }

  // Update attendance record
  Future<AttendanceRecord> updateAttendanceRecord(
    AttendanceRecord record,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockAttendanceRecords.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _mockAttendanceRecords[index] = record;
    }

    return record;
  }

  // Get attendance statistics for a student
  Future<Map<String, int>> getStudentAttendanceStats(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final records = _mockAttendanceRecords
        .where((record) => record.studentId == studentId)
        .toList();

    return {
      'total': records.length,
      'present': records
          .where((r) => r.status == AttendanceStatus.present)
          .length,
      'absent': records
          .where((r) => r.status == AttendanceStatus.absent)
          .length,
      'late': records.where((r) => r.status == AttendanceStatus.late).length,
    };
  }

  // Get attendance statistics for a session
  Future<Map<String, int>> getSessionAttendanceStats(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final records = _mockAttendanceRecords
        .where((record) => record.sessionId == sessionId)
        .toList();

    return {
      'total': records.length,
      'present': records
          .where((r) => r.status == AttendanceStatus.present)
          .length,
      'absent': records
          .where((r) => r.status == AttendanceStatus.absent)
          .length,
      'late': records.where((r) => r.status == AttendanceStatus.late).length,
    };
  }

  // Get overall attendance statistics
  Future<Map<String, dynamic>> getOverallStats() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final totalRecords = _mockAttendanceRecords.length;
    final presentCount = _mockAttendanceRecords
        .where((r) => r.status == AttendanceStatus.present)
        .length;
    final absentCount = _mockAttendanceRecords
        .where((r) => r.status == AttendanceStatus.absent)
        .length;
    final lateCount = _mockAttendanceRecords
        .where((r) => r.status == AttendanceStatus.late)
        .length;

    return {
      'total': totalRecords,
      'present': presentCount,
      'absent': absentCount,
      'late': lateCount,
      'presenceRate': totalRecords > 0
          ? (presentCount / totalRecords) * 100
          : 0.0,
    };
  }

  // Delete attendance record
  Future<bool> deleteAttendanceRecord(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockAttendanceRecords.removeWhere((record) => record.id == id);
    return true;
  }

  // Generate mock attendance for testing
  Future<void> generateMockAttendance(
    String sessionId,
    List<Student> students,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Remove existing records for this session
    _mockAttendanceRecords.removeWhere(
      (record) => record.sessionId == sessionId,
    );

    // Generate random attendance
    for (var student in students) {
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      AttendanceStatus status;

      if (random < 7) {
        status = AttendanceStatus.present;
      } else if (random < 9) {
        status = AttendanceStatus.late;
      } else {
        status = AttendanceStatus.absent;
      }

      final record = AttendanceRecord(
        id: '${sessionId}_${student.id}_${DateTime.now().millisecondsSinceEpoch}',
        sessionId: sessionId,
        studentId: student.id,
        studentName: student.fullName,
        status: status,
        timestamp: DateTime.now(),
      );

      _mockAttendanceRecords.add(record);
    }
  }
}
