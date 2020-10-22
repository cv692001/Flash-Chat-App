import 'package:flutter/material.dart';
import 'package:flash_chat/layout.dart';

class Button_widget extends StatelessWidget {
  Button_widget({this.color, this.text, this.onpress});

  final Color color;
  final String text;
  final Function onpress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: displayWidth(context) * 0.033),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: displayWidth(context) * 0.55,
          height: displayWidth(context) * 0.1166,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
