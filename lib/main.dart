import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:green_path/register_screen.dart';
import 'package:green_path/theme_provider.dart'; // Import the ThemeProvider
import 'firebase_options.dart';
import 'profile_screen.dart';
import 'feature_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS (optional for Android)
  await messaging.requestPermission();

  // Get FCM token for the device
  String? token = await messaging.getToken();
  print("FCM Token: $token"); // This token can be used to send notifications

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  // Listen to foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Message title: ${message.notification?.title}');
      print('Message body: ${message.notification?.body}');
      // Optionally show a local notification (with a package like flutter_local_notifications)
    }
  });

  runApp(const MyApp());
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Green Path',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const WelcomeScreen(),
            routes: {
              '/Login': (context) => LoginScreen(onTap: () {}),
              '/Register': (context) => const RegisterScreen(onTap: null),
              '/profile': (context) => const ProfileScreen(),
              '/Feature': (context) => const FeatureScreen(),
            },
          );
        },
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/startingscreen.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with logo, text, and button
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/green_path_logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Green Path',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 77, 8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Every Action Counts: Learn, Act, Inspire!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 15, 95, 19),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/Login'); // Navigate to Login screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 15, 92, 19),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 8),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
