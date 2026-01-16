import 'package:flutter/material.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(colors: [whiteColor, whiteColor]),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(gradient: gradient, borderRadius: borderRadius),
        child: Container(padding: padding, alignment: Alignment.center, child: child),
      ),
    );
  }
}
