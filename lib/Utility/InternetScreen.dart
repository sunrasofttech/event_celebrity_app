import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobi_user/Utility/MainColor.dart';

// class InternetScreen extends StatelessWidget {
//   const InternetScreen({Key? key, required this.onClose}) : super(key: key);
//   final Function onClose;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(width: 200, height: 200, child: Lottie.asset("asset/icon/no-internet.json")),
//             Text("No Internet", style: AppTheme().blackStyle),
//             Text("Make sure you are connected to internet", style: AppTheme().blackStyle),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: FloatingActionButton.extended(
//                 extendedPadding: const EdgeInsets.symmetric(horizontal: 100),
//                 onPressed: () {
//                   // NetworkBloc().add(NetworkObserve());
//                   onClose();
//                   Navigator.pop(context);
//                 },
//                 label: const Text("CLOSE"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class InternetScreen extends StatefulWidget {
  const InternetScreen({Key? key, required this.onClose}) : super(key: key);
  final Function onClose;

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  bool showTurnOnInternetButton = false;
  late StreamSubscription<InternetStatus> _subscription;

  @override
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((callback) {
      checkInternet();
      _subscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
        checkInternet();
      });
    });

    super.initState();
  }

  Future<void> checkInternet() async {
    try {
      final result = await http.get(Uri.parse("https://www.google.com")).timeout(const Duration(seconds: 5));
      if (result.statusCode == 200) {
        // Internet is working, even if slow
        setState(() => showTurnOnInternetButton = false);
      } else {
        setState(() => showTurnOnInternetButton = true);
      }
    } catch (_) {
      // No internet
      setState(() => showTurnOnInternetButton = true);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0),
      body: Stack(
        children: [
          // Bottom orange curve
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.3,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: playColor,
                borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 200), topRight: Radius.elliptical(400, 200)),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                /// "Oops!" text
                const Text("Oops!", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFF004172))),

                const SizedBox(height: 16),

                /// Image
                Image.asset(
                  "asset/icon/no_internet.png", // Update this to your asset path
                  height: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 32),

                /// Info Text
                const Text(
                  "Make sure you are connected\nto internet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 120),

                /// Close Button
                ElevatedButton(
                  onPressed: () {
                    if (showTurnOnInternetButton) {
                      AppSettings.openAppSettings(type: AppSettingsType.dataRoaming);
                    } else {
                      widget.onClose();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor: Colors.black12,
                  ),
                  child: const Text("Turn On Your Internet", style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.w600)),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
