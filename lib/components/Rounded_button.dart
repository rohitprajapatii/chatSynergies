import 'package:flutter/material.dart';


class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String selectedText;
  final Color selectedColor;
  RoundedButton({this.selectedText, this.onPressed, this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: selectedColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$selectedText',style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}