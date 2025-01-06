class Task {
  final String id;
  final String subject;
  final String status;
  final String description;

  Task({required this.id, required this.subject, required this.status, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['Id'] ?? '',
      subject: json['Subject'] ?? '',
      status: json['Status'] ?? '',
      description: json['Description'] ?? ''
    );
  }
}
