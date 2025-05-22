import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({super.key});

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
