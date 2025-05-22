import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? callback;
  final Widget title;
  final Color primaryColor;
  final double? elevation;
  const ButtonWidget({Key? key, this.callback, required this.title, required this.primaryColor, this.elevation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: callback,
        child: Padding(padding: const EdgeInsets.all(12.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [title])),
      ),
    );
  }
}
