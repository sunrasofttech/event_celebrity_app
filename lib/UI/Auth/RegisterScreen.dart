import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/UI/Auth/LoginScreen.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';

import '../../Utility/CustomTextField.dart';
import '../MainScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

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
                child: const Icon(Icons.arrow_left, color: greyColor),
              ),

              const SizedBox(height: 40),

              /// Title
              const Text(
                "Register yourself",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),

              /// Subtitle
              RichText(
                text: TextSpan(
                  text: "By signing up you are accepting to our ",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                  children: const [
                    TextSpan(
                      text: "Terms and Conditions",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(child: Image.asset('asset/icons/signup_img.png', height: 180, fit: BoxFit.contain)),
              const SizedBox(height: 20),

              /// Mobile
              CustomTextField(
                controller: mobileController,
                hintText: "Mobile",
                keyboardType: TextInputType.phone,
                prefixIcon: IconsaxPlusBold.mobile,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              const SizedBox(height: 12),

              const Center(child: Text("OR", style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w600))),

              const SizedBox(height: 12),

              /// Email
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: IconsaxPlusBold.sms,
              ),

              const SizedBox(height: 12),

              /// Password
              CustomTextField(
                maxLine: 1,
                controller: passwordController,
                hintText: "Password",
                prefixIcon: IconsaxPlusBold.lock,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? IconsaxPlusBold.eye_slash : IconsaxPlusBold.eye, color: Colors.grey),
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
              ),

              const SizedBox(height: 40),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                child: SimpleButton(
                  onPressed: () {
                    // TODO: handle register
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      (c) => false,
                    );
                  },
                  title: "Continue",
                ),
              ),

              const SizedBox(height: 40),

              /// Already a member?
              Center(
                child: InkWell(
                  onTap: () {
                    log("message");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already a member? ",
                      style: const TextStyle(color: Colors.black45),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
