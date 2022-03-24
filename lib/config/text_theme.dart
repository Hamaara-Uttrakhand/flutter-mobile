import 'package:flutter/material.dart';

class CustomTetxStyle {
  //Following is the text style, we will be using for the splash heading
  static TextStyle splashHeading(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
        fontFamily: 'Sedan SC',
        fontWeight: FontWeight.normal,
        color: Colors.black);
  }

  //Following is the text style, we will be using for the splash sub- heading
  static TextStyle splashSubHeading(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
        fontFamily: 'Medina Script',
        fontWeight: FontWeight.normal,
        color: Colors.black);
  }
}
