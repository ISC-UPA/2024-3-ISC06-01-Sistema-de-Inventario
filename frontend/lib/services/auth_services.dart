import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/model_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  // In-memory user data
  User? _currentUserData;

  // Save token and expiration
  Future<void> saveToken(String token, String expiration) async {
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'token_expiration', value: expiration);
  }

  // Read token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Read token expiration
  Future<String?> getTokenExpiration() async {
    return await _storage.read(key: 'token_expiration');
  }

  // Delete token and expiration
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'token_expiration');
  }

  // Save user data
  Future<void> saveUserData(User userData) async {
    _currentUserData = userData;
    await _storage.write(key: 'user_data', value: json.encode(userData.toJson()));
  }

  // Load user data
  Future<User?> getUserData() async {
    if (_currentUserData != null) return _currentUserData;

    final userDataString = await _storage.read(key: 'user_data');
    if (userDataString != null) {
      _currentUserData = User.fromJson(json.decode(userDataString));
    }
    return _currentUserData;
  }

  // Clear user data
  Future<void> clearUserData() async {
    _currentUserData = null;
    await _storage.delete(key: 'user_data');
  }

  // Save user credentials
  Future<void> saveUserCredentials(String username, String password) async {
    await _storage.write(key: 'username', value: username);
    await _storage.write(key: 'password', value: password);
  }

  // Load user credentials
  Future<Map<String, String>?> getUserCredentials() async {
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');
    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }
  
  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  // Clear user credentials
  Future<void> clearUserCredentials() async {
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }

  // Login with API
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.222:5000/api/Auth/login'),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Save token, expiration, user data, and user credentials
      await saveToken(data['token'], data['expiration']);
      await saveUserData(User.fromJson(data['user'])); // Assuming 'user' contains user data
      await saveUserCredentials(username, password);

      debugPrint('Token is valid and saved. Expires at: ${data['expiration']}');
      return true;
    } else {
      debugPrint('Error: Invalid username or password.');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await deleteToken();
    await clearUserData();
    await clearUserCredentials();
  }

  // Check if user credentials are available
  Future<bool> hasUserCredentials() async {
    final credentials = await getUserCredentials();
    return credentials != null;
  }
}