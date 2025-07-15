class ActivityLog {
  final String id; // Unique log entry ID
  final String? userId; // ID of the user who performed the activity
  final String? type; // Type of activity
  final String? details; // Details about the activity
  final DateTime? timestamp; // When the activity occurred

  ActivityLog({
    required this.id,
    this.userId,
    this.type,
    this.details,
    this.timestamp,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      details: json['details'] as String? ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  static DateTime? _parseTimestamp(dynamic ts) {
    if (ts == null) return null;
    if (ts is String) {
      return DateTime.tryParse(ts);
    }
    if (ts is Map && ts['seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch((ts['seconds'] as int) * 1000);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'details': details,
      // 'timestamp' is typically set by the backend or Firestore server
    };
  }

  ActivityLog copyWith({
    String? id,
    String? userId,
    String? type,
    String? details,
    DateTime? timestamp,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Optional: If you use Firestore DocumentSnapshot elsewhere
  // factory ActivityLog.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return ActivityLog.fromJson({
  //     ...data,
  //     'id': doc.id,
  //   });
  // }
}
