import 'package:flutter/material.dart';

class TextCustomizado extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;

  TextCustomizado({
    this.text,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
