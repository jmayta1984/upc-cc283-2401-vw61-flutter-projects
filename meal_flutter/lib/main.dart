import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meal_flutter/screens/google_sign_in_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  initialize() async {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDy-bNo5e_Y0mclegfeDuf5GLj3trX9yJI",
            appId:
                "232325318560-imacc8vc7er3m01gu6q975d9u3u0tlit.apps.googleusercontent.com",
            messagingSenderId: "jmayta@pucp.edu.pe",
            projectId: "fir-flutter-e0fe8"));
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    return const MaterialApp(
      home: Scaffold(
        body: GoogleSignInScreen(),
      ),
    );
  }
}
