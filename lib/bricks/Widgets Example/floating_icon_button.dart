import 'package:flutter/material.dart';

class FloatingActionButtonFb3 extends StatelessWidget {
  final Function() onPressed;
  final Widget icon;
  final Color color;
  const FloatingActionButtonFb3(
      {required this.onPressed,
      required this.icon,
      this.color = Colors.blue,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: onPressed,
      child: icon,
    );
  }
}