import 'package:flutter/material.dart';
import 'package:planner_celebrity/UI/Auth/LoginScreen.dart';
import 'package:planner_celebrity/UI/Auth/WelcomeScreen.dart';
import 'package:planner_celebrity/UI/MainScreen.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((
      callback,
    ) async {
      await Future.delayed(const Duration(seconds: 3));
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getString(sharedPrefUserIdKey);
      if (userId == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (c) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (c) => false,
        );
      }
    });
    // WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((callback) async {
    //   await Future.delayed(const Duration(seconds: 3));
    //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomeScreen()), (c) => false);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Image.asset(
            "asset/icons/Splash.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(appLogo, height: 200, width: 200),
            ),
          ),
        ],
      ),
    );
  }
}
