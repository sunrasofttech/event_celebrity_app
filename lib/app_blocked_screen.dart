import 'dart:io';

import 'package:flutter/material.dart';

class AppBlockedScreen extends StatefulWidget {
  const AppBlockedScreen({super.key});

  @override
  State<AppBlockedScreen> createState() => _AppBlockedScreenState();
}

class _AppBlockedScreenState extends State<AppBlockedScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((callback) async {
      await Future.delayed(const Duration(seconds: 1));
      // exit(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("This app is blocked due to unverified activities")));
  }
}
