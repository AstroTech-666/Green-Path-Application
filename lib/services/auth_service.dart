// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Start the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Exit if the user cancels sign-in
      if (googleUser == null) {
        if (kDebugMode) {
          print('Google sign-in canceled by user.');
        }
        return;
      }

      // Obtain Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Handle the signed-in user
      if (user != null) {
        await _handleUserInFirestore(user, context);
      } else {
        throw Exception("Google sign-in failed: No user information found.");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during Google sign-in: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in. Please try again.')),
      );
    }
  }

  /// Handle user data in Firestore and navigate accordingly
  Future<void> _handleUserInFirestore(User user, BuildContext context) async {
    try {
      final DocumentReference userDoc =
          _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot snapshot = await userDoc.get();

      // If user data doesn't exist, create it
      if (!snapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'sustainability_goal': '', // Default field value
        });
        _navigateTo(context, '/profile');
      } else {
        // Check if user data is incomplete
        final data = snapshot.data() as Map<String, dynamic>;
        if (data['name'] == null || data['photoUrl'] == null) {
          _navigateTo(context, '/profile');
        } else {
          _navigateTo(context, '/Feature');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling user data in Firestore: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  /// Navigate to a given route if the context is mounted
  void _navigateTo(BuildContext context, String route) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}
