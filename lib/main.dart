import 'package:flutter/material.dart';
import 'screens/first_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:smart_agility_training/screens/auth/login_screen.dart';
import 'package:smart_agility_training/screens/auth/registration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        FirstScreen.id: (context) => FirstScreen(),
        //ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}

