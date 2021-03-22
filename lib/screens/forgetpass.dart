import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/ScreenButtonWidget.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  String forgetid;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Please Enter your email',
            style: kSendButtonTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: kTextDecoration.copyWith(
                labelText: 'Enter email',
              ),
              onChanged: (value) {
                forgetid = value;
              },
            ),
          ),
          ScreenButton(
              color: Colors.lightBlueAccent,
              onpressed: () async {
                try {
                  await _auth.sendPasswordResetEmail(email: forgetid);
                  print('msg sent');
                } on Exception catch (e) {
                  // TODO
                  print(e);
                }
              },
              buttonName: 'Send email'),
        ],
      ),
    );
  }
}
