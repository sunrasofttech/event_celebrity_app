import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/UI/Profile/AboutScreen.dart';
import 'package:planner_celebrity/UI/Profile/AccountSettingScreen.dart';
import 'package:planner_celebrity/UI/Profile/ChatScreen.dart';
import 'package:planner_celebrity/UI/Profile/FAQScreen.dart';
import 'package:planner_celebrity/UI/Profile/MyBookingScreen.dart';
import 'package:planner_celebrity/UI/Profile/NotificationScreen.dart';
import 'package:planner_celebrity/UI/Profile/change_password.dart';
import 'package:planner_celebrity/UI/Profile/earnings_screen.dart';
import 'package:planner_celebrity/UI/Profile/edit_profile_screen.dart';
import 'package:planner_celebrity/UI/Profile/payment_setting_screen.dart';
import 'package:planner_celebrity/UI/Profile/share_feedback_screen.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "All Settings",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage("asset/icons/app_img.png"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Celebrity Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "+91 982423899",
                        style: TextStyle(fontSize: 14, color: greyColor),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfileScreen()));
                  },
                  child: Icon(IconsaxPlusBold.edit, color: greyColor)),
              ],
            ),

            const SizedBox(height: 24),

            // --- My Bookings ---
            ProfileTile(
              icon: IconsaxPlusBold.calendar_1,
              title: "My Bookings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookingsScreen()),
                );
              },
            ),

            // --- Manage Section ---
            ProfileTile(
              icon: IconsaxPlusBold.dollar_square,
              title: "Earnings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EarningsScreen()),
                );
              },
            ),
            ProfileTile(
              icon: IconsaxPlusBold.user,
              title: "Account settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSettingScreen(),
                  ),
                );
              },
            ),
            ProfileTile(
              icon: IconsaxPlusBold.wallet_3,
              title: "Payment settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSettingScreen(),
                  ),
                );
              },
            ),
            const ProfileTile(
              icon: IconsaxPlusBold.calendar,
              title: "Update Availability Dates",
            ),

            const SizedBox(height: 24),

            // --- Support Section ---
            const SectionTitle("Support"),
            ProfileTile(
              icon: IconsaxPlusBold.message_question,
              title: "Frequently asked questions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },
            ),
            ProfileTile(
              icon: IconsaxPlusBold.message,
              title: "Chat with us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatAssistantScreen(),
                  ),
                );
              },
            ),
             ProfileTile(
              icon: IconsaxPlusBold.password_check,
              title: "Change Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
            ),
            ProfileTile(
              icon: IconsaxPlusBold.message_text_1,
              title: "Share feedback",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareFeedbackScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // --- More Section ---
            const SectionTitle("More"),
            ProfileTile(
              icon: IconsaxPlusBold.notification,
              title: "Notification settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),

            ProfileTile(
              icon: IconsaxPlusBold.information,
              title: "About us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            const ProfileTile(icon: IconsaxPlusBold.logout, title: "Logout"),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;

  const ProfileTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: greyColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: titleTextColor,
          ),
        ),
        trailing: Icon(
          IconsaxPlusBold.arrow_right_3,
          size: 16,
          color: greyColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}
