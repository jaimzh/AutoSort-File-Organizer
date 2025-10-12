// ----------------- LogEntry Model -----------------
class LogEntry {
  final String type;
  final String action;
  final String message;
  final String status;
  final String? fileName;
  final String? fileCategory;
  final DateTime timestamp;

  LogEntry({
    required this.type,
    required this.action,
    required this.message,
    required this.status,
    this.fileName,
    this.fileCategory,
    required this.timestamp,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      type: json['type'] ?? '',
      action: json['action'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      fileName: json['file']?['name'],
      fileCategory: json['file']?['category'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}





