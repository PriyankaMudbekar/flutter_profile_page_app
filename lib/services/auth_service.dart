import '../models/user_model.dart';
import '../services/db_service.dart';

class AuthService {
  final DBService _dbService = DBService();
  UserModel? _loggedInUser;

  // ✅ Register User
  Future<bool> registerUser(UserModel user) async {
    try {
      await _dbService.registerUser(user);
      return true;
    } catch (e) {
      return false; // Registration failed (e.g., duplicate email)
    }
  }

  // ✅ Login User & Fetch Full Details
  Future<UserModel?> login(String email, String password) async {
    _loggedInUser = await _dbService.loginUser(email, password);
    return _loggedInUser;
  }

  // ✅ Fetch Logged-in User for Profile Page (Only Name, Phone, and Email)
  Future<UserModel?> getLoggedInUser() async {
    if (_loggedInUser != null) {
      return await _dbService.getLoggedInUser(_loggedInUser!.email);
    }
    return null;
  }

  // ✅ Logout (Clears the logged-in user from memory)
  void logout() {
    _loggedInUser = null;
  }
}



/*
import '../models/user_model.dart';
import '../services/db_service.dart';

class AuthService {
  final DBService _dbService = DBService();
  UserModel? _loggedInUser;

  // ✅ Register User
  Future<bool> registerUser(UserModel user) async {
    try {
      await _dbService.registerUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Login User & Fetch Details from `users` Table
  Future<UserModel?> login(String email, String password) async {
    _loggedInUser = await _dbService.loginUser(email, password);
    return _loggedInUser;
  }

  // ✅ Fetch Logged-in User (Profile Page)
  Future<UserModel?> getLoggedInUser() async {
    return _loggedInUser;
  }

  // ✅ Logout (Just clears user from memory, doesn't delete from DB)
  void logout() {
    _loggedInUser = null;
  }
}
*/