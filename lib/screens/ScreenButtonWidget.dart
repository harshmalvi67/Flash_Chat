import 'package:flutter/material.dart';

class ScreenButton extends StatelessWidget {
  Color color;
  var onpressed;
  String buttonName;
  @override
  ScreenButton(
      {@required this.color,
      @required this.onpressed,
      @required this.buttonName});
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
