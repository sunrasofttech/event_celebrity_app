import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../Utility/MainColor.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key, this.upcoming = false});
  final bool upcoming;
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int selectedTab = 0;
  final List<String> tabs = ['Events', 'Celebrity/Artist'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Header --------
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text("My Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 20),

              // -------- Tabs --------
              widget.upcoming
                  ? Text("Upcoming", style: TextStyle(color: titleTextColor, fontWeight: FontWeight.w600, fontSize: 16))
                  : Row(
                    children: List.generate(tabs.length, (index) {
                      final isSelected = selectedTab == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedTab = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
                          decoration: BoxDecoration(
                            border: isSelected ? const Border(bottom: BorderSide(color: primaryColor, width: 2)) : null,
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                              color: isSelected ? primaryColor : greyColor,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

              const SizedBox(height: 16),

              // -------- Booking Card --------
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://4kwallpapers.com/images/walls/thumbs_3t/23702.jpg",
                              width: 100,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Event Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Eric Prydz India 2025 | Mumbai",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: titleTextColor,
                                  ),
                                ),
                                Text("2 guests", style: TextStyle(fontSize: 12, color: greyColor)),
                                const SizedBox(height: 8),

                                Text("Date", style: TextStyle(fontSize: 12, color: greyColor)),
                                const Text(
                                  "Sun, 5 Oct, 7:00 PM",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleTextColor),
                                ),
                                const SizedBox(height: 8),

                                Text("Location", style: TextStyle(fontSize: 12, color: greyColor)),
                                const Text(
                                  "Pune, Maharashtra",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleTextColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Bottom Row
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Color(0xFFECECEC),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8FFF1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: const Text(
                              "Booked",
                              style: TextStyle(color: lightGreenColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "View Details",
                                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              const Icon(IconsaxPlusBold.arrow_right_3, color: greyColor, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
