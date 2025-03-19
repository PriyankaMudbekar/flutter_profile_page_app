import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'viewmodels/auth_view_model.dart';
import 'viewmodels/post_view_model.dart';
import 'viewmodels/registration_view_model.dart';
import 'views/login_screen.dart';

void main() {
  // ✅ Initialize SQLite for Linux & Windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => PostViewModel()),
        ChangeNotifierProvider(create: (context) => RegistrationViewModel()), // ✅ Added RegistrationViewModel
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "MVVM Posts App",
        theme: ThemeData(
          useMaterial3: true, // ✅ Added Material 3
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // 🌟 Material 3 color scheme
        ),
        home: LoginScreen(),
      ),
    );
  }
}
