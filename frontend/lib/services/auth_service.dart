import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/model_user.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  // In-memory user data
  User? _currentUser;

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Read token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Save user data
  Future<void> saveUserData(User user) async {
    _currentUser = user;
    await _storage.write(key: 'user_data', value: json.encode(user.toJson()));
  }

  // Load user data
  Future<User?> getUserData() async {
    if (_currentUser != null) return _currentUser;

    final userDataString = await _storage.read(key: 'user_data');
    if (userDataString != null) {
      _currentUser = User.fromJson(json.decode(userDataString));
    }
    return _currentUser;
  }

  // Clear user data
  Future<void> clearUserData() async {
    _currentUser = null;
    await _storage.delete(key: 'user_data');
  }

  // Login with API
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Save token and user data
      await saveToken(data['token']);
      await saveUserData(User.fromJson(data['user']));

      return true;
    } else {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await deleteToken();
    await clearUserData();
  }

  // Interceptor to add token to requests
  Future<http.Response> get(String url) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> delete(String url) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }
}