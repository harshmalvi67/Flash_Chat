import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/ScreenButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'forgetpass.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  String name;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: kheroTag,
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              ScreenButton(
                  color: Color(0xff009688),
                  onpressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final currentUser =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      //print(currentUser);
                      if (currentUser.user.emailVerified) {
                        Navigator.pushReplacementNamed(context, '/chat_screen');
                      } else {
                        Alert(
                            context: context,
                            type: AlertType.warning,
                            title: 'Please Verify your Email',
                            desc: 'Verification mail sent to your email',
                            buttons: [
                              DialogButton(
                                child: Text('Okay'),
                                onPressed: () {
                                  currentUser.user
                                      .sendEmailVerification()
                                      .catchError((e) {
                                    print(e);
                                  });
                                  Navigator.pop(context);
                                },
                                width: 120,
                                color: Color(0xff009688),
                              )
                            ]).show();
                      }
                    } catch (e) {
                      print(e);
                      Alert(
                          context: context,
                          type: AlertType.error,
                          title: 'Error',
                          desc: 'Please enter correct email & password',
                          buttons: [
                            DialogButton(
                              child: Text('Okay'),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                              color: Color(0xff009688),
                            )
                          ]).show();
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  buttonName: 'Login'),
              SizedBox(
                height: 10,
              ),
              ScreenButton(
                  color: Color(0xff009688),
                  onpressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPassword()));
                  },
                  buttonName: 'Forget Password?'),
            ],
          ),
        ),
      ),
    );
  }
}
