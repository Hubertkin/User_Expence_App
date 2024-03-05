import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// A stateless widget that adapts its appearance based on the platform (iOS or Android).
class AdaptiveFlatButton extends StatelessWidget {
  // The text to be displayed on the button.
  final String text;
  // The function to be executed when the button is pressed.
  final Function handler;

  // Constructor for the AdaptiveFlatButton, takes a text and a handler function as parameters.
  const AdaptiveFlatButton(this.text, this.handler);

  @override
  // Builds the widget based on the platform.
  Widget build(BuildContext context) {
    // If the platform is iOS, return a CupertinoButton.
    return Platform.isIOS
        ? CupertinoButton(
            // The function to be executed when the button is pressed.
            onPressed: () {
              handler();
            },
            // The text to be displayed on the button.
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        // If the platform is not iOS (Android), return a TextButton.
        : TextButton(
            // The style of the button when it's not pressed.
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.purple)),
            // The function to be executed when the button is pressed.
            onPressed: () {
              handler();
            },
            // The text to be displayed on the button.
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
