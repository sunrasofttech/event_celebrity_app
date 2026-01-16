import 'package:flutter/material.dart';

import 'MainColor.dart';

class SimpleButton extends StatelessWidget {
  final String? title;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? fgColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? radius;
  const SimpleButton({
    Key? key,
    this.title,
    required this.onPressed,
    this.padding,
    this.bgColor,
    this.fgColor,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgColor ?? primaryColor,
        foregroundColor: fgColor ?? Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: radius ?? BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(title ?? "Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
