import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';
import '../model/task.dart';


class SalesforceService {
  final AuthService _authService;

  SalesforceService(this._authService);

  Future<List<Task>> openFetchTasks() async {
    try {
      final url = '${_authService.instanceUrl}/${dotenv.env['API_ENDPOINT']!}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${_authService.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debugging: Log the entire response data to see its structure
        print('Response data: $data');

        // Check if the 'records' key exists and contains a list
        if (data['records'] != null && data['records'] is List) {
          final List<dynamic> records = data['records'];

          // Map the list of records to a List<Task> using fromJson
          return records.map((json) => Task.fromJson(json)).toList();
        } else {
          throw Exception('No records found in the response');
        }
      } else {
        throw Exception('Failed to fetch tasks: ${response.body}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow;
    }
  }

  Future<List<Completed>> fetchCompletedTasks() async {
    try {
      final url = '${_authService.instanceUrl}/${dotenv.env['COMPLETED']!}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${_authService.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debugging: Log the entire response data to see its structure
        print('Response data: $data');

        // Check if the 'records' key exists and contains a list
        if (data['records'] != null && data['records'] is List) {
          final List<dynamic> records = data['records'];

          // Map the list of records to a List<Task> using fromJson
          return records.map((json) => Completed.fromJson(json)).toList();
        } else {
          throw Exception('No records found in the response');
        }
      } else {
        throw Exception('Failed to fetch tasks: ${response.body}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow;
    }
  }

}
