import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String _clientId = dotenv.env['CLIENT_ID']!;
  final String _clientSecret = dotenv.env['CLIENT_SECRET']!;
  final String _loginUrl = dotenv.env['LOGIN_URL']!;
  final String _grantType = dotenv.env['GRANT_TYPE']!;
  final String _tokenEndpoint = dotenv.env['TOKEN_POINT']!;

  late String _accessToken;
  late String _instanceUrl;

  // Authenticate using client credentials
  Future<void> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('$_loginUrl$_tokenEndpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': _grantType,
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _accessToken = data['access_token'];
        _instanceUrl = data['instance_url'];

        print('Authentication successful');
        print('Access Token: $_accessToken');
        print('Instance URL: $_instanceUrl');
      } else {
        throw Exception('Failed to authenticate: ${response.body}');
      }
    } catch (e) {
      print('Authentication error: $e');
      rethrow;
    }
  }

  // Get the access token
  String get accessToken => _accessToken;

  // Get the instance URL
  String get instanceUrl => _instanceUrl;
}
