import 'package:flutter/material.dart';

import '../../Utility/MainColor.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
              ),

              const SizedBox(height: 40),

              /// Title
              const Text("Log In", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
              //OTP has been sent to your mobile number
              /// Subtitle
              RichText(
                text: TextSpan(
                  text: "OTP has been sent to your mobile number ",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                  children: const [
                    // TextSpan(
                    //   text: "Terms and Conditions",
                    //   style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                    // ),
                    // TextSpan(text: " and "),
                    // TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 40),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: handle register
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Already a member?
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Resend OTP?",
                    style: const TextStyle(color: Colors.black45),
                    children: [
                      TextSpan(
                        text: "Resend",
                        style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
