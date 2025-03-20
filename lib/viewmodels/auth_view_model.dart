import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _loggedInUser;

  UserModel? get loggedInUser => _loggedInUser;

  // ✅ Register User
  Future<bool> register(UserModel user) async {
    bool isRegistered = await _authService.registerUser(user);
    notifyListeners();
    return isRegistered;
  }

  // ✅ Load Logged-in User (For Profile Page)
  Future<void> loadUser() async {
    _loggedInUser = await _authService.getLoggedInUser();
    notifyListeners();
  }

  // ✅ Login User
  Future<bool> login(String email, String password) async {
    _loggedInUser = await _authService.login(email, password);
    notifyListeners();
    return _loggedInUser != null;
  }

  // ✅ Logout User
  void logout() {
    _authService.logout();
    _loggedInUser = null;
    notifyListeners();
  }

  // ✅ Update User Name in Database
  Future<void> updateUserName(String firstName, String lastName) async {
    if (_loggedInUser == null) return;

    // Update user in database
    await _authService.updateUserName(_loggedInUser!.id ?? 0, firstName, lastName);


    _loggedInUser = UserModel(
      id: _loggedInUser!.id ?? 0, // Ensures id is never null
      firstName: firstName,
      lastName: lastName,
      email: _loggedInUser!.email,
      phone: _loggedInUser!.phone,
      dob: _loggedInUser!.dob,
      gender: _loggedInUser!.gender,
      password: _loggedInUser!.password,
    );


    notifyListeners();
  }
}




/*
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _loggedInUser;

  UserModel? get loggedInUser => _loggedInUser;

  // ✅ Register User
  Future<bool> register(UserModel user) async {
    bool isRegistered = await _authService.registerUser(user);
    notifyListeners();
    return isRegistered;
  }

  // ✅ Load Logged-in User (For Profile Page)
  Future<void> loadUser() async {
    _loggedInUser = await _authService.getLoggedInUser();
    notifyListeners();
  }

  // ✅ Login User
  Future<bool> login(String email, String password) async {
    _loggedInUser = await _authService.login(email, password);
    notifyListeners();
    return _loggedInUser != null;
  }

  // ✅ Logout User
  void logout() {
    _authService.logout();
    _loggedInUser = null;
    notifyListeners();
  }
}
*/