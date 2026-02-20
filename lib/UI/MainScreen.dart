import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/SessionKeyBloc/SessionKeyCubit.dart';
import 'package:planner_celebrity/Bloc/SessionKeyBloc/SessionKeyState.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/avaibility/get_avalibility/get_avalibility_cubit.dart';
import 'package:planner_celebrity/Bloc/get_all_events/get_all_events_cubit.dart';
import 'package:planner_celebrity/Bloc/get_dashboard/get_dashboard_cubit.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/Repository/EncryptionInterceptor.dart';
import 'package:planner_celebrity/Repository/EncryptionService.dart';
import 'package:planner_celebrity/UI/Auth/LoginScreen.dart';
import 'package:planner_celebrity/UI/Pages/BookingScreen.dart';
import 'package:planner_celebrity/UI/Pages/CalendarScreen.dart';
import 'package:planner_celebrity/UI/Pages/DashboardScreen.dart';
import 'package:planner_celebrity/UI/Pages/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/MainColor.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1; // Default to Home tab

  late final List<Widget> pages;

  Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Exit App"),
                content: const Text("Are you sure you want to exit?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    // Initialize pages here directly (no need for post frame callback)
    pages = [CalendarScreen(showButton: false), DashBoardScreen(), BookingScreen(), ProfileScreen()];
    context.read<SessionKeyCubit>().sessionKey();
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
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitPopup(context);
        return shouldExit;
      },
      child: BlocListener<SessionKeyCubit, SessionKeyState>(
        listener: (context, state) async {
          if(state is SessionKeyErrorState && state.error.contains("Not authorized, no token")){
             try {
                  Navigator.pop(context);
                  final pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  log("Shared Pref is Clear");
                  EncryptionService().resetKey();
                  EncryptionInterceptor().clearInitialization();
                  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
                  await _secureStorage.delete(key: dotenv.env['ENCRYPTION_KEY_REQUEST'] ?? 'ENCRYPTION_KEY_REQUEST');
                  await _secureStorage.deleteAll(aOptions: AndroidOptions(encryptedSharedPreferences: true));
                } catch (e, s) {
                  log("------>>  $e --- $s");
                } finally {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (c) => false,
                  );
                }
          }
        },
        child: Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: SafeArea(
            child: SizedBox(
              height: 85,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                    BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.calendar), label: "Availability"),
                    BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.home), label: "Home"),
                    BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.book_1), label: "Bookings"),
                    BottomNavigationBarItem(icon: Icon(IconsaxPlusBold.profile), label: "Profile"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
