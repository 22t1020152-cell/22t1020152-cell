import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? error;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.error,
  });

  bool get isSuccess => accessToken != null && error == null;
}

class UserData {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }
}

class AuthService {
  static const String _baseUrl = 'https://dummyjson.com/auth';

  /// Login with username and password.
  /// Checks local registered users first, then tries remote API.
  /// Returns AuthResponse with accessToken, refreshToken, and expiresIn.
  static Future<AuthResponse> login(String username, String password) async {
    try {
      // First check if user exists in local storage (registered users)
      final prefs = await SharedPreferences.getInstance();
      final localUserJson = prefs.getString('user_$username');
      if (localUserJson != null) {
        final localUser = jsonDecode(localUserJson) as Map<String, dynamic>;
        final storedPassword = localUser['password'] as String?;
        if (storedPassword == password) {
          // Local registration matched — generate mock tokens
          final mockAccessToken =
              'local_token_${username}_${DateTime.now().millisecondsSinceEpoch}';
          final mockRefreshToken =
              'local_refresh_${username}_${DateTime.now().millisecondsSinceEpoch}';
          return AuthResponse(
            accessToken: mockAccessToken,
            refreshToken: mockRefreshToken,
            expiresIn: 30,
          );
        } else {
          return AuthResponse(error: 'Invalid credentials');
        }
      }

      // If not found locally, try remote API
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AuthResponse(
          accessToken: json['accessToken'] as String?,
          refreshToken: json['refreshToken'] as String?,
          expiresIn: json['expiresInMins'] as int?,
        );
      } else {
        return AuthResponse(error: 'Login failed: ${response.statusCode}');
      }
    } catch (e) {
      return AuthResponse(error: 'Error: $e');
    }
  }

  /// Fetch current user data using the access token.
  /// For local registered users, extract data from token (username).
  static Future<UserData?> getUser(String accessToken) async {
    try {
      // Check if this is a local token
      if (accessToken.startsWith('local_token_')) {
        // Extract username from token format: local_token_<username>_<timestamp>
        final parts = accessToken.split('_');
        if (parts.length >= 3) {
          final username = parts[2];
          final prefs = await SharedPreferences.getInstance();
          final userJson = prefs.getString('user_$username');
          if (userJson != null) {
            final userData = jsonDecode(userJson) as Map<String, dynamic>;
            return UserData(
              id: userData['id'] ?? username.hashCode,
              username: userData['username'] as String,
              email: userData['email'] as String? ?? '',
              firstName: userData['firstName'] as String? ?? '',
              lastName: userData['lastName'] as String? ?? '',
            );
          }
        }
        return null;
      }

      // Remote API user fetch
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return UserData.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Refresh the access token using the refresh token.
  static Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AuthResponse(
          accessToken: json['accessToken'] as String?,
          refreshToken: json['refreshToken'] as String?,
          expiresIn: json['expiresInMins'] as int?,
        );
      } else {
        return AuthResponse(error: 'Refresh failed: ${response.statusCode}');
      }
    } catch (e) {
      return AuthResponse(error: 'Error: $e');
    }
  }

  /// Register a new user. Stores credentials locally so they can login.
  /// Returns success/error map.
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> payload,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = payload['username'] as String?;
      final password = payload['password'] as String?;

      if (username == null ||
          username.isEmpty ||
          password == null ||
          password.isEmpty) {
        return {
          'success': false,
          'error': 'Username and password are required',
        };
      }

      // Check if user already exists locally
      final existingUser = prefs.getString('user_$username');
      if (existingUser != null) {
        return {'success': false, 'error': 'User already exists'};
      }

      // Store user data locally
      final userData = {
        'username': username,
        'password': password,
        'firstName': payload['firstName'] ?? '',
        'lastName': payload['lastName'] ?? '',
        'email': payload['email'] ?? '',
      };
      await prefs.setString('user_$username', jsonEncode(userData));

      return {'success': true, 'data': userData};
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }
}
