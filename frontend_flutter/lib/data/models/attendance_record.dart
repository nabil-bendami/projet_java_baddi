enum AttendanceStatus { present, absent, late }

class AttendanceRecord {
  final String id;
  final String sessionId;
  final String studentId;
  final String studentName;
  final AttendanceStatus status;
  final DateTime timestamp;
  final String? remarks;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.status,
    required this.timestamp,
    this.remarks,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
        orElse: () => AttendanceStatus.absent,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'studentId': studentId,
      'studentName': studentName,
      'status': status.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'remarks': remarks,
    };
  }

  String getStatusLabel() {
    switch (status) {
      case AttendanceStatus.present:
        return 'Présent';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'En retard';
    }
  }

  AttendanceRecord copyWith({
    String? id,
    String? sessionId,
    String? studentId,
    String? studentName,
    AttendanceStatus? status,
    DateTime? timestamp,
    String? remarks,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      remarks: remarks ?? this.remarks,
    );
  }
}
