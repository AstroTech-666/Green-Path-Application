import 'package:flutter/material.dart';
import 'package:green_path/register_screen.dart';
import 'package:green_path/login_screen.dart'; // Import your LoginScreen

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(
        onTap: togglePages, // Pass the toggle function to LoginScreen
      );
    } else {
      return RegisterScreen(
        onTap: togglePages, // Pass the toggle function to RegisterScreen
      );
    }
  }
}
