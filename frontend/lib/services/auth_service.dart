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
  DateTime? _tokenExpiry;

  // Configuration for testing
  bool isTesting = true;

  // Simulated token for testing
  final String simulatedToken = 'simulated_token';

  // Save token and expiry time
  Future<void> saveToken(String token, DateTime expiry) async {
    if (isTesting) {
      _tokenExpiry = expiry;
    } else {
      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'token_expiry', value: expiry.toIso8601String());
      _tokenExpiry = expiry;
    }
  }

  // Read token
  Future<String?> getToken() async {
    if (isTesting) {
      return simulatedToken;
    }

    final token = await _storage.read(key: 'auth_token');
    final expiryString = await _storage.read(key: 'token_expiry');
    if (expiryString != null) {
      _tokenExpiry = DateTime.parse(expiryString);
    }

    if (_tokenExpiry != null && DateTime.now().isAfter(_tokenExpiry!)) {
      await deleteToken();
      return null;
    }

    return token;
  }

  // Delete token
  Future<void> deleteToken() async {
    if (isTesting) {
      _tokenExpiry = null;
    } else {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'token_expiry');
      _tokenExpiry = null;
    }
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

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token != null) {
      final user = await getUserData();
      if (user != null) {
        _currentUser = user;
        return true;
      }
    }
    return false;
  }

  // Login with API
  Future<bool> login(String email, String password) async {
    if (isTesting) {
      await saveToken(simulatedToken, DateTime.now().add(Duration(hours: 1)));
      return true;
    }

    final response = await http.post(
      Uri.parse('http://localhost:5000/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Save token and user data
      final tokenExpiry = DateTime.now().add(Duration(seconds: data['expiresIn']));
      await saveToken(data['token'], tokenExpiry);
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
    if (token == null) {
      throw Exception('Token has expired');
    }
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
    if (token == null) {
      throw Exception('Token has expired');
    }
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
    if (token == null) {
      throw Exception('Token has expired');
    }
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
    if (token == null) {
      throw Exception('Token has expired');
    }
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