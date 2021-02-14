import 'package:flutter/material.dart';

class TextCustomizado extends StatelessWidget {
  String text;
  double fontSize;

  TextCustomizado({
    this.text,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}
