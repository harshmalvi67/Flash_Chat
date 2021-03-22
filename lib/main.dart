import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/welcomeScreen',
      routes: {
        '/welcomeScreen': (context) => WelcomeScreen(),
        '/chat_screen': (context) => ChatScreen(),
        '/register_screen': (context) => RegistrationScreen(),
        '/login_screen': (context) => LoginScreen()
      },
      home: WelcomeScreen(),
    );
  }
}
