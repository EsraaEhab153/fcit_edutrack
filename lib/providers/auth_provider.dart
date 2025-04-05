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

  // Check if current user has admin role
  Future<bool> isAdmin() async {
    if (_currentUser == null) {
      await initialize();
    }
    print("Checking if user is admin. User role: ${_currentUser?.role}");
    return _currentUser?.role?.toUpperCase() == 'ADMIN';
  }

  // Check if current user has professor role
  Future<bool> isProfessor() async {
    if (_currentUser == null) {
      await initialize();
    }
    print("Checking if user is professor. User role: ${_currentUser?.role}");
    return _currentUser?.role?.toUpperCase() == 'PROFESSOR';
  }

  // Check if current user has student role
  Future<bool> isStudent() async {
    if (_currentUser == null) {
      await initialize();
    }
    print("Checking if user is student. User role: ${_currentUser?.role}");
    // Default to student if no role specified
    return _currentUser?.role == null ||
        _currentUser?.role?.toUpperCase() == 'STUDENT';
  }

  // Get user role
  String? get userRole => _currentUser?.role;

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

          // Debug the token data
          print("Token data: ${decodedToken.toString()}");

          // Try different possible key names for the user ID
          String? userId = decodedToken['sub'] ??
              decodedToken['id'] ??
              decodedToken['userId'] ??
              decodedToken['user_id'];

          if (userId == null || userId.isEmpty) {
            print("Warning: Could not extract user ID from token");
          }

          // Look for role in different possible fields
          String? userRole = decodedToken['role'] ??
              decodedToken['authorities']?.toString() ??
              decodedToken['scope']?.toString() ??
              decodedToken['roles']?.toString();

          if (userRole != null) {
            // Check for Spring Security format like "[ROLE_ADMIN]" or "ROLE_ADMIN"
            if (userRole.contains('ADMIN')) {
              userRole = 'ADMIN';
            } else if (userRole.contains('PROFESSOR')) {
              userRole = 'PROFESSOR';
            } else if (userRole.contains('STUDENT')) {
              userRole = 'STUDENT';
            }
            print("Extracted role from token: $userRole");
          } else {
            print("Warning: Could not extract role from token");
          }

          // Create user from token data
          _currentUser = User(
            id: userId ?? '',
            username: decodedToken['username'] ?? '',
            fullName: decodedToken['fullName'] ?? decodedToken['name'] ?? '',
            email: decodedToken['email'] ?? '',
            role: userRole,
            emailVerified: true, // If they have a token, they're verified
          );

          print(
              "Initialized user with ID: ${_currentUser?.id} and role: ${_currentUser?.role}");
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

        // Decode the token to extract user ID
        final decodedToken = JwtDecoder.decode(_token!);
        print("Full decoded token: $decodedToken");

        // Try different possible key names for the user ID
        String? userId = decodedToken['sub'] ??
            decodedToken['id'] ??
            decodedToken['userId'] ??
            decodedToken['user_id'] ??
            response['data']['id'] ??
            response['data']['userId'];

        if (userId == null || userId.isEmpty) {
          print("Warning: Could not extract user ID from token or response");
        } else {
          print("Login successful, extracted user ID: $userId");
        }

        // Extract role from token
        String? userRole = decodedToken['role'] ??
            decodedToken['authorities']?.toString() ??
            decodedToken['scope']?.toString() ??
            decodedToken['roles']?.toString();

        if (userRole != null) {
          // Check for Spring Security format like "[ROLE_ADMIN]" or "ROLE_ADMIN"
          if (userRole.contains('ADMIN')) {
            userRole = 'ADMIN';
          } else if (userRole.contains('PROFESSOR')) {
            userRole = 'PROFESSOR';
          } else if (userRole.contains('STUDENT')) {
            userRole = 'STUDENT';
          }
          print("Extracted role from token: $userRole");
        } else {
          print("No role found in token, checking response data...");
          userRole = response['data']['role'];
        }

        // Extract user details from response
        _currentUser = User(
          id: userId ?? '', // Use extracted ID
          username: response['data']['username'] ?? '',
          fullName: response['data']['fullName'] ?? '',
          email: response['data']['email'] ?? '',
          role: userRole, // Get role from token or response
          emailVerified: true, // If login successful, assume verified
        );

        print("User logged in with role: ${_currentUser?.role}");
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

    print("AuthProvider: logout() called");

    try {
      print("AuthProvider: clearing token from API service");
      await _apiService.clearToken();

      print("AuthProvider: setting token and current user to null");
      _token = null;
      _currentUser = null;

      print("AuthProvider: logout completed successfully");
    } catch (e) {
      print('AuthProvider: Logout error: $e');
      // Even if there's an error, we should still clear local state
      _token = null;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
      print("AuthProvider: notified listeners of logout");
    }
  }

  // Login with email
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.loginWithEmail(email, password);

      if (response['success'] && response['data']['token'] != null) {
        _token = response['data']['token'];

        // Decode the token to extract user ID
        final decodedToken = JwtDecoder.decode(_token!);

        // Try different possible key names for the user ID
        String? userId = decodedToken['sub'] ??
            decodedToken['id'] ??
            decodedToken['userId'] ??
            decodedToken['user_id'] ??
            response['data']['id'] ??
            response['data']['userId'];

        if (userId == null || userId.isEmpty) {
          print("Warning: Could not extract user ID from token or response");
        } else {
          print("Login successful, extracted user ID: $userId");
        }

        // Extract user details from response
        _currentUser = User(
          id: userId ?? '', // Use extracted ID
          username: response['data']['username'] ?? '',
          fullName: response['data']['fullName'] ?? '',
          email: response['data']['email'] ?? '',
          role: decodedToken['role'], // Get role from token
          emailVerified: true, // If login successful, assume verified
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login with email error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if a string is an email
  bool isEmail(String input) {
    // Simple email regex pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(input);
  }

  // Smart login - determine if input is username or email
  Future<bool> smartLogin(String usernameOrEmail, String password) async {
    if (isEmail(usernameOrEmail)) {
      print("Login attempt with email: $usernameOrEmail");
      return loginWithEmail(usernameOrEmail, password);
    } else {
      print("Login attempt with username: $usernameOrEmail");
      return login(usernameOrEmail, password);
    }
  }
}
