import 'package:flutter/material.dart';

class GlowingWhatsAppButton extends StatefulWidget {
  const GlowingWhatsAppButton({Key? key}) : super(key: key);

  @override
  State<GlowingWhatsAppButton> createState() => _GlowingWhatsAppButtonState();
}

class _GlowingWhatsAppButtonState extends State<GlowingWhatsAppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.withOpacity(0.2),
          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 15, spreadRadius: 4)],
        ),
        child: Image.asset("asset/icons/glow_whatsapp.png", height: 50, width: 50, fit: BoxFit.cover),
      ),
    );
  }
}
