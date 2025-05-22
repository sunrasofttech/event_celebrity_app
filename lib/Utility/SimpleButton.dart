import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final TextStyle style;
  final Color primaryColor;
  final double padding;
  final BorderRadius radius;
  const SimpleButton(
      {Key? key,
      required this.title,
      required this.callback,
      required this.style,
      required this.padding,
      required this.primaryColor,
      required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: radius,
                side: BorderSide(color: primaryColor == Colors.white ? Colors.black : Colors.transparent))),
        onPressed: callback,
        child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: style),
              ],
            )));
  }
}
