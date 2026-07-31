import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import 'package:google_fonts/google_fonts.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';

class MainScreen extends StatefulWidget {
  final bool? isApproved;
  const MainScreen({super.key, this.isApproved});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1; // Default to Home tab
  bool _isDialogShowing = false;

  late final List<Widget> pages;

  void _showUnauthorizedDialog(BuildContext context, String message) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      IconsaxPlusBold.clock,
                      color: Colors.orange,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Account Under Review",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.isNotEmpty && message != "null"
                        ? message
                        : "Your celebrity profile is currently under review by our admin team. Account approval usually takes within 2 hours.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          IconsaxPlusBold.timer_1,
                          size: 18,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Approval wait time: ~2 Hours",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SimpleButton(
                        onPressed: () {
                          _isDialogShowing = false;
                          Navigator.pop(ctx);
                          context.read<GetProfileCubit>().getProfile();
                        },
                        title: "Check Approval Status",
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          _isDialogShowing = false;
                          try {
                            Navigator.pop(ctx);
                            final pref = await SharedPreferences.getInstance();
                            await pref.clear();
                            log("Shared Pref is Clear");
                            EncryptionService().resetKey();
                            EncryptionInterceptor().clearInitialization();
                            final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
                            await secureStorage.delete(key: dotenv.env['ENCRYPTION_KEY_REQUEST'] ?? 'ENCRYPTION_KEY_REQUEST');
                            await secureStorage.deleteAll(aOptions: const AndroidOptions(encryptedSharedPreferences: true));
                          } catch (e, s) {
                            log("------>>  $e --- $s");
                          } finally {
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                (c) => false,
                              );
                            }
                          }
                        },
                        child: Text(
                          "Log Out",
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

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
    pages = [
      CalendarScreen(showButton: false),
      DashBoardScreen(),
      BookingScreen(),
      ProfileScreen(),
    ];
    context.read<SessionKeyCubit>().sessionKey();
    // context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
    context.read<GetDashboardCubit>().getDash();
    context.read<GetAvalibilityCubit>().GetAvailability();
    context.read<SettingCubit>().getSettingsApiCall();
    context.read<GetAvalibilityCubit>().GetAvailability();
    context.read<GetProfileCubit>().getProfile();
    context.read<GetAllEventsCubit>().getAllEvent();

    if (widget.isApproved == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUnauthorizedDialog(
          context,
          "Your celebrity profile is currently pending approval by the admin team. App access will be granted once approved.",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitPopup(context);
        return shouldExit;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<SessionKeyCubit, SessionKeyState>(
            listener: (context, state) async {
              if (state is SessionKeyErrorState) {
                final err = state.error.toLowerCase();
                if (err.contains("not authorized") ||
                    err.contains("under review") ||
                    err.contains("not approved")) {
                  _showUnauthorizedDialog(context, state.error);
                }
              }
            },
          ),
          BlocListener<GetProfileCubit, GetProfileState>(
            listener: (context, state) {
              if (state is GetProfileLoadedState) {
                if (state.model.data?.isApproved == false) {
                  _showUnauthorizedDialog(
                    context,
                    "Your celebrity profile is currently pending approval by the admin team. App access will be granted once approved.",
                  );
                }
              }
              if (state is GetProfileErrorState) {
                final err = state.error.toLowerCase();
                if (err.contains("celebrity not authorized") ||
                    err.contains("not authorized") ||
                    err.contains("under review") ||
                    err.contains("not approved")) {
                  _showUnauthorizedDialog(context, state.error);
                }
              }
            },
          ),
        ],
        child: Scaffold(
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
                    if (index == 0) {
                      context.read<GetAvalibilityCubit>().GetAvailability();
                    }
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
        ),
      ),
    );
  }
}
