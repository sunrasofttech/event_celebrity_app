import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/UI/Pages/BookingScreen.dart';
import 'package:planner_celebrity/UI/Pages/CalendarScreen.dart';
import 'package:planner_celebrity/UI/Pages/DashboardScreen.dart';
import 'package:planner_celebrity/UI/Pages/profile_screen.dart';
import 'package:planner_celebrity/UI/Profile/SettingScreen.dart';

import '../Utility/MainColor.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1; // Default to Home tab

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages here directly (no need for post frame callback)
    pages = [
      CalendarScreen(), // Bookings
      DashBoardScreen(), // Home
      BookingScreen(), // Funds
      ProfileScreen(), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 85,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
            
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
          
              elevation: 8,
              selectedItemColor: primaryColor,
              unselectedItemColor: greyColor,
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(IconsaxPlusBold.calendar),
                  label: "Availability",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconsaxPlusBold.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconsaxPlusBold.book_1),
                  label: "Bookings",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconsaxPlusBold.profile),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
