import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:news_app/utils/api_constants.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  String? _userId;

  bool get isloading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;
  String? get token => _token;

  AuthProvider() {
    _loadStoredToken();
  }

  //loading token from secure storage on startup
  Future<void> _loadStoredToken() async {
    _token = await _storage.read(key: 'jwt_token');
    _userId = await _storage.read(key: 'user_id');
    notifyListeners();
  }

  //helper to set login state securely
  void _setLoginState(String token, String userId) async {
    _token = token;
    _userId = userId;
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'user_id', value: userId);
    notifyListeners();
  }

  //login
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await http.post(
        Uri.parse(ApiConstants.authLoginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _setLoginState(data['token'], data['userId']);
        _setLoading(false);
        return true;
      } else {
        final data = jsonDecode(response.body);
        _setError(data['message'] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError("Could not connect to the server.");
      return false;
    }
  }

  //signup/register
  Future<bool> signUp(String email, String password, String name) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await http.post(
        Uri.parse(ApiConstants.authRegisterEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        
        return await signIn(email, password);
      } else {
        final data = jsonDecode(response.body);
        _setError(data['message'] ?? 'Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError("Could not connect to the server.");
      return false;
    }
  }

  //sign Out
  Future<void> signOut() async {
    _token = null;
    _userId = null;
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_id');
    notifyListeners();
  }

  
  Future<bool> resetPassword(String email) async {
    _setError("Password reset is not yet implemented on the custom backend.");
    return false;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}