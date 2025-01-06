import 'package:flutter/material.dart';
import '../model/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.id),
        subtitle: Text(task.subject),
        trailing: Text(task.status),
        onTap: () {
          // Navigate to Task Details Screen
        },
      ),
    );
  }
}
