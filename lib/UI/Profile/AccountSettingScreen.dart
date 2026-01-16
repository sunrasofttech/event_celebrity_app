import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/UI/Profile/SettingScreen.dart';

import '../../Utility/MainColor.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white),
            child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Account Settings",
          style: TextStyle(color: titleTextColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileTile(icon: IconsaxPlusBold.security, title: "Account Settings", onTap: () {}),
            ProfileTile(icon: IconsaxPlusBold.profile, title: "Profile", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
