import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../Utility/MainColor.dart';

class Tile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final void Function()? onTap;

  const Tile({this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: icon == null ? null : Icon(icon, color: greyColor),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: titleTextColor)),
        trailing: Switch(value: true, onChanged: (v) {}),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          "Notifications",
          style: TextStyle(color: titleTextColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Profile Header ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Enable all", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text("Activate all notifications", style: TextStyle(fontSize: 14, color: greyColor)),
                    ],
                  ),
                ),
                Switch(value: true, onChanged: (v) {}),
              ],
            ),

            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Order and bookings", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text("Receive updates related to your booking", style: TextStyle(fontSize: 12, color: greyColor)),
              ],
            ),
            const SizedBox(height: 14),
            Tile(title: "Email", onTap: () {}),
            Tile(title: "Push", onTap: () {}),
            Tile(title: "SMS", onTap: () {}),
            Tile(title: "Whatsapp", onTap: () {}),

            const SizedBox(height: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Reminder", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text("Receive updates related to your offers", style: TextStyle(fontSize: 12, color: greyColor)),
              ],
            ),
            const SizedBox(height: 14),
            Tile(title: "Email", onTap: () {}),
            Tile(title: "Push", onTap: () {}),
            Tile(title: "SMS", onTap: () {}),
            Tile(title: "Whatsapp", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
