import 'package:flutter/widgets.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/services/auth_service.dart';
import 'package:wish_list_client/services/user_service.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  Future<void> loadUser() async {
    try {
      _user = await _userService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      print('Failed to load user: $e');
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);

      print(response);

      await SharedPrefs.saveToken(response['access_token']);
      await loadUser();
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }

  Future<void> register(String email, String password, String nickname) async {
    try {
      final response = await _authService.register(email, password, nickname);

      print(response);

      await SharedPrefs.saveToken(response['token']);
      await loadUser();
    } catch (e) {
      print('Registration failed: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await SharedPrefs.clearToken();
    _user = null;
    notifyListeners();
  }
}
