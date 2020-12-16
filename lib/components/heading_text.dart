import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final Color color;
  HeadingText(this.text, {this.color = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: color,
      ),
    );
  }
}
