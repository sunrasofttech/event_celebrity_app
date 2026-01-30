import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/avaibility/get_avalibility/get_avalibility_cubit.dart';
import 'package:planner_celebrity/Bloc/get_all_events/get_all_events_cubit.dart';
import 'package:planner_celebrity/Bloc/get_dashboard/get_dashboard_cubit.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/UI/Pages/BookingScreen.dart';
import 'package:planner_celebrity/UI/Pages/CalendarScreen.dart';
import 'package:planner_celebrity/UI/Pages/DashboardScreen.dart';
import 'package:planner_celebrity/UI/Pages/profile_screen.dart';

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
      CalendarScreen(), 
      DashBoardScreen(), 
      BookingScreen(),
      ProfileScreen(),
    ];

    // context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
    context.read<GetDashboardCubit>().getDash();
    context.read<GetAvalibilityCubit>().GetAvailability();
    context.read<SettingCubit>().getSettingsApiCall();
    context.read<GetAvalibilityCubit>().GetAvailability();
    context.read<GetProfileCubit>().getProfile();
    context.read<GetAllEventsCubit>().getAllEvent();
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
