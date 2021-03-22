import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/ScreenButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  //Do something with the user input.
                  name = value;
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter your Name'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
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
                      final newuser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      FirebaseFirestore.instance.collection('users').doc().set({
                        'name': name,
                        'uid': newuser.user.uid,
                        'email': email,
                      });
                      if (newuser != null) {
                        bool emailSent = true;
                        _auth.currentUser
                            .sendEmailVerification()
                            .catchError((e) {
                          emailSent = false;
                          print(e);
                        });
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: 'Email Sent',
                          desc: 'Verifiation Mail sent to your Email.',
                          buttons: [
                            DialogButton(
                              child: Text('Okay'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 120,
                              color: Color(0xff009688),
                            ),
                          ],
                        ).show();
                        if (emailSent) {
                          Navigator.pushNamed(context, '/login_screen');
                        }
                      }
                    } catch (e) {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: 'Error',
                        desc: 'The email is already used by another account',
                        buttons: [
                          DialogButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            width: 120,
                            color: Color(0xff009688),
                          ),
                        ],
                      ).show();
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  buttonName: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
