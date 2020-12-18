import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  color: Colors.transparent,
  border: Border(
    top: BorderSide.none,
  ),
);

const kInputContainerDecoration = InputDecoration(
  hintText: 'Enter your email.',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

InputDecoration chatTextFieldInputDecoration() {
  return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 10),
      border: new OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(
          const Radius.circular(20.0),
        ),
      ),
      prefixIcon: Icon(
        Icons.keyboard,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.black.withOpacity(0.1),
      hintText: "Type message",
      hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          wordSpacing: 1,
          fontWeight: FontWeight.w400));
}
