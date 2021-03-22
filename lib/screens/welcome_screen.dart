import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

import 'ScreenButtonWidget.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  //AnimationController animationController;

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: kheroTag,
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    speed: Duration(milliseconds: 100),
                    text: ['Flash Chat'],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              ScreenButton(
                color: Color(0xff009688),
                onpressed: () {
                  Navigator.pushNamed(context, '/login_screen');
                },
                buttonName: 'Login',
              ),
              ScreenButton(
                  color: Color(0xff00D9BB),
                  onpressed: () {
                    Navigator.pushNamed(context, '/register_screen');
                    //Go to registration screen.
                  },
                  buttonName: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
