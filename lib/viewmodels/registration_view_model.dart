import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';

class RegistrationViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();

  // ✅ Register User Method
  Future<bool> registerUser(UserModel user, BuildContext context) async {
    try {
      await _dbService.registerUser(user);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successful!"))
      );

      notifyListeners();
      return true;
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Failed!"))
      );
      return false;
    }
  }
}
