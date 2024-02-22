import 'package:flutter/material.dart';

Widget customButton (String buttonText,onPressed){
  return SizedBox(
    width: 200,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
            color: Colors.white, fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.orangeAccent,
        elevation: 3,
      ),
    ),
  );
}
