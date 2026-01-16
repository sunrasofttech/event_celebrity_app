import 'package:flutter/material.dart';
import 'package:planner_celebrity/Utility/CustomFont.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool mainNotification = false;
  bool starNotification = false;
  bool gameNotification = false;

  String select = "";
  bool flags = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Setting")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: playColor,
                /* shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: blueColor,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),*/
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Login Setting", style: whiteStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    RadioListTile(
                      title: Text("Login with Username Password", style: whiteStyle),
                      value: "Login with Username Password",
                      groupValue: select,
                      onChanged: (val) {
                        setState(() {
                          select = val.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Direct Login", style: whiteStyle),
                      value: "Direct Login",
                      groupValue: select,
                      onChanged: (val) {
                        setState(() {
                          select = val.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: playColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Notification Settings",
                            style: whiteStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      title: Text("Main Notification", style: whiteStyle),
                      value: mainNotification,
                      onChanged: (val) {
                        setState(() {
                          mainNotification = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text("Game Notification", style: whiteStyle),
                      value: gameNotification,
                      onChanged: (val) {
                        setState(() {
                          gameNotification = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text("Starline Notification", style: whiteStyle),
                      value: starNotification,
                      onChanged: (val) {
                        setState(() {
                          starNotification = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
