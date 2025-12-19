class Session {
  final String id;
  final String module;
  final String professorId;
  final String professorName;
  final String group;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String room;
  final int duration; // in minutes
  final String? description;

  Session({
    required this.id,
    required this.module,
    required this.professorId,
    required this.professorName,
    required this.group,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.duration,
    this.description,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      module: json['module'] as String,
      professorId: json['professorId'] as String,
      professorName: json['professorName'] as String,
      group: json['group'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      room: json['room'] as String,
      duration: json['duration'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module': module,
      'professorId': professorId,
      'professorName': professorName,
      'group': group,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'duration': duration,
      'description': description,
    };
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get isPast {
    return date.isBefore(DateTime.now());
  }

  bool get isFuture {
    return date.isAfter(DateTime.now());
  }

  Session copyWith({
    String? id,
    String? module,
    String? professorId,
    String? professorName,
    String? group,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? room,
    int? duration,
    String? description,
  }) {
    return Session(
      id: id ?? this.id,
      module: module ?? this.module,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      group: group ?? this.group,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      duration: duration ?? this.duration,
      description: description ?? this.description,
    );
  }
}
