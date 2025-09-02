import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/auth_service.dart';
import '../core/services/database_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((authState) {
      final AuthChangeEvent event = authState.event;
      final Session? session = authState.session;
      
      if (event == AuthChangeEvent.signedIn && session != null) {
        _user = session.user;
        _loadUserData();
      } else if (event == AuthChangeEvent.signedOut) {
        _user = null;
        _userModel = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      _userModel = await _databaseService.getUser(_user!.id);
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signIn(email, password);
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name, UserRole role) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.signUp(email, password);
      
      if (response.user != null) {
        final userModel = UserModel(
          id: response.user!.id,
          name: name,
          email: email,
          role: role,
          createdAt: DateTime.now(),
        );

        await _databaseService.createUser(userModel);
        return true;
      }
      return false;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}