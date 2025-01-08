import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../service/salesforce_service.dart';
import '../auth/auth_service.dart';
import '../model/task.dart';

class overDueTask extends StatefulWidget {
  const overDueTask({super.key});

  @override
  State<overDueTask> createState() => _overDueTaskState();
}

class _overDueTaskState extends State<overDueTask> {
  late Future<List<Completed>> _tasksCompletedFuture;
  late AuthService _authService;
  late SalesforceService _salesforceService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _tasksCompletedFuture = Future.value([]);
    _authenticateAndLoadTasks();
  }

  Future<void> _authenticateAndLoadTasks() async {
    try {
      await _authService.authenticate();
      _salesforceService = SalesforceService(_authService);
      setState(() {
        _tasksCompletedFuture = _salesforceService.fetchCompletedTasks();
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
      body: FutureBuilder<List<Completed>>(
        future: _tasksCompletedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }

          final completedTask = snapshot.data!;
          return ListView.builder(
            itemCount: completedTask.length,
            itemBuilder: (context, index) {
              final task = completedTask[index];
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
