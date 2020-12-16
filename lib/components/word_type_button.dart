import 'package:flutter/material.dart';

class WordTypeButton extends StatelessWidget {
  final bool isActive;
  final String wordType;
  final double topLeftBorderRadius;
  final double topRightBorderRadius;
  final double bottomLeftBorderRadius;
  final double bottomRightBorderRadius;
  final Function onTap;

  WordTypeButton({
    @required this.wordType,
    this.isActive = false,
    this.topLeftBorderRadius = 0,
    this.topRightBorderRadius = 0,
    this.bottomLeftBorderRadius = 0,
    this.bottomRightBorderRadius = 0,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 10.0,
        ),
        child: Text(
          '$wordType',
          style: TextStyle(
            color: isActive ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRightBorderRadius),
            bottomRight: Radius.circular(bottomRightBorderRadius),
            topLeft: Radius.circular(topLeftBorderRadius),
            bottomLeft: Radius.circular(bottomLeftBorderRadius),
          ),
        ),
      ),
    );
  }
}
