import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  User? _currentUser;
  String? _token;
  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;

  // Initialize the provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        // Check if token is expired
        if (JwtDecoder.isExpired(token)) {
          await _apiService.clearToken();
          _token = null;
          _currentUser = null;
        } else {
          _token = token;
          // Extract user info from token
          final decodedToken = JwtDecoder.decode(token);

          // Create user from token data
          _currentUser = User(
            id: decodedToken['sub'] ?? '',
            username: decodedToken['username'] ?? '',
            fullName: decodedToken['fullName'] ?? '',
            email: decodedToken['email'] ?? '',
            role: decodedToken['role'],
            emailVerified: true, // If they have a token, they're verified
          );
        }
      }
    } catch (e) {
      // Handle error
      print('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);

      if (response['success'] && response['data']['token'] != null) {
        _token = response['data']['token'];

        // Extract user details from response
        _currentUser = User(
          id: '', // ID might not be in response, can be extracted from token
          username: response['data']['username'] ?? '',
          fullName: response['data']['fullName'] ?? '',
          email: response['data']['email'] ?? '',
          role: null, // Role might be in token
          emailVerified: true, // If login successful, assume verified
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register user
  Future<Map<String, dynamic>> register(
      String username, String password, String fullName, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.register(username, password, fullName, email);
      return response;
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'Network error, please try again later',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verify email
  Future<bool> verifyEmail(String email, String code) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.verifyEmail(email, code);

      if (response['success'] && response['data']['token'] != null) {
        _token = response['data']['token'];

        // Extract user details from response
        _currentUser = User(
          id: '', // ID might not be in response
          username: response['data']['username'] ?? '',
          fullName: response['data']['fullName'] ?? '',
          email: response['data']['email'] ?? '',
          role: null, // Role might be in token
          emailVerified: true,
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Email verification error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.clearToken();
      _token = null;
      _currentUser = null;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
