import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  UserData? _userData;
  bool _isAuthenticated = false;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  UserData? get userData => _userData;
  bool get isAuthenticated => _isAuthenticated;

  /// Called after successful login. Stores tokens and fetches user data.
  Future<void> login(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    // Fetch user data
    final user = await AuthService.getUser(accessToken);
    if (user != null) {
      _userData = user;
      _isAuthenticated = true;
      notifyListeners();
    } else {
      // Token valid but user fetch failed; still mark as authenticated
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  /// Refresh the access token using the stored refresh token.
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) return false;

    final response = await AuthService.refreshToken(_refreshToken!);
    if (response.isSuccess) {
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Logout: clear all tokens and user data.
  void logout() {
    _accessToken = null;
    _refreshToken = null;
    _userData = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
