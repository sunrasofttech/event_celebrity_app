import 'package:flutter/material.dart';

import '../../Utility/SimpleButton.dart';
import 'RegisterScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),

          /// --- Illustration image
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Image.asset('asset/icons/signup_img.png', fit: BoxFit.contain),
            ),
          ),

          /// --- Bottom curved container
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              width: double.infinity,
              color: const Color(0xFFE53935), // red background
              padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 30),
              child: Column(
                children: [
                  Text(
                    "Register Yourself and start your managing your event dates",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: SimpleButton(
                      bgColor: Colors.white,
                      fgColor: Colors.black,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                      },
                      title: "Continue",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom top curve for bottom section
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
