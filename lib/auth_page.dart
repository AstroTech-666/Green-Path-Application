import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_path/login_or_register_page.dart';
import 'profile_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            print("Connection State: ${snapshot.connectionState}");
            print("User Signed In: ${snapshot.hasData}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              // User is signed in
              print("User Email: ${snapshot.data?.email}");
              return const ProfileScreen();
            } else {
              // User is not signed in
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}
