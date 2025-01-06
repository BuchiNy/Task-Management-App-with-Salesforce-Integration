import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../service/salesforce_service.dart';
import '../auth/auth_service.dart';
import '../model/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _tasksFuture;
  late AuthService _authService;
  late SalesforceService _salesforceService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _tasksFuture = Future.value([]);
    _authenticateAndLoadTasks();
  }

  Future<void> _authenticateAndLoadTasks() async {
    try {
      await _authService.authenticate();
      _salesforceService = SalesforceService(_authService);
      setState(() {
        _tasksFuture = _salesforceService.fetchTasks();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error during authentication or task fetching: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Tasks'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }

          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                child: ListTile(
                  title: Text(task.subject),
                  subtitle: Text(task.description),
                  trailing: Text(task.status),
                  onTap: () {
                    // Navigate to Task Details Screen
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
