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
            apiKey: "",
            appId:
                "",
            messagingSenderId: "",
            projectId: ""));
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
