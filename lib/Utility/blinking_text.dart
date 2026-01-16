import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final String status;
  const BlinkingText({Key? key, required this.status}) : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: true);

    _opacity = Tween<double>(begin: 1.0, end: 0.59).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = widget.status == "OPEN";
    final isClosedToday = widget.status.toLowerCase() == "today_close";

    String displayText =
        isClosedToday
            ? "Declared\nHoliday"
            : isRunning
            ? ""
            : "";

    Color displayColor =
        isClosedToday
            ? Colors.redAccent
            : isRunning
            ? Colors.green
            : Colors.redAccent;

    return isRunning
        ? AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(opacity: _opacity.value, child: child);
          },
          child: Text(
            displayText,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        )
        : Text(
          displayText,
          textAlign: TextAlign.end,
          style: TextStyle(color: displayColor, fontWeight: FontWeight.w600, fontSize: 14),
        );
  }
}
