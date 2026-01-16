import 'package:flutter/material.dart';

class GradientTextField extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GradientTextField({super.key, this.icon, this.label, this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF32343D), Color(0xFF141519)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4)],
        ),
        child: Row(
          children: [
            // Icon(icon, color: Colors.grey[400], size: 20),
            if (child != null)
              Expanded(child: child!)
            else
              Expanded(child: Text(label ?? "", style: TextStyle(color: Colors.grey[400], fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
