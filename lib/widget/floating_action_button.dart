import 'package:flutter/material.dart';

class FloatingActionButtonCustomizado extends StatelessWidget {
  Widget icon;
  String text;
  Color color;
  Function onPressed;

  FloatingActionButtonCustomizado({
    this.icon,
    this.text,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      backgroundColor: color,
      heroTag: null,
      onPressed: onPressed,
    );
  }
}
