import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobi_user/UI/MainScreen.dart';
import 'package:mobi_user/UI/UI_new/SelectLanguageScreen.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const MethodChannel _sourceChannel = MethodChannel('source_channel');
  // ✅ Get App Source (Play Store or Website)
  static Future<String?> getAppSource() async {
    try {
      final String source = await _sourceChannel.invokeMethod('getSource');
      return source;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      final userid = await pref.getString("key");
      final _source = await getAppSource();
      print("------------------------------------------------->>>>>>> $_source");
      await Future.delayed(const Duration(seconds: 1));

      if (userid != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SelectLanguageScreen()), (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/icons/splash_bg.png"))),
        // decoration: splashGradientDecoration(),
        child: Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage("asset/icons/logo.png"))),
          ),
        ),
      ),
    );
  }
}
