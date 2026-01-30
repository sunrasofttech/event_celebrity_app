import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingState.dart';
import 'package:planner_celebrity/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Bloc/LogOutCubit/LogOutCubit.dart';
import '../Utility/CustomFont.dart';
import '../Utility/const.dart';
import '../main.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<bool> _getNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("show_notification") ?? true; // Default ON
  }

  Future<void> _setNotificationPref(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_notification", value);
  }

  Widget _tile({required Widget leading, required Widget title, required void Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      decoration: bidDecoration().copyWith(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFF0D0D0D), Color(0xFF2D2D2D)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        boxShadow: [
          BoxShadow(color: Color(0xFFFFFFFF).withOpacity(0.2), blurRadius: 2, spreadRadius: 2, offset: Offset(0, 0)),
          BoxShadow(color: Color(0xFFE0E0E040).withOpacity(0.1), blurRadius: 3, spreadRadius: 2, offset: Offset(0, 0)),
        ],
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        leading: leading,
        title: title,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blackColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
              builder: (context, state) {
                if (state is UserProfileFetchedState) {
                 

                  return Container(
                    margin: const EdgeInsets.only(top: 25, left: 6, right: 6, bottom: 6),
                    // padding: EdgeInsets.only(top: 50),
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              state.user.data?.profilePictureUrl?.isNotEmpty ?? false
                                  ? CachedNetworkImage(
                                    imageUrl: "${Constants.baseUrl}${state.user.data?.profilePictureUrl}",
                                    errorWidget: (context, _, child) {
                                      return CircleAvatar(
                                        maxRadius: 30,
                                        backgroundImage: const AssetImage("asset/icons/drawer/profile_pic.png"),
                                      );
                                    },
                                    imageBuilder: (context, image) {
                                      return CircleAvatar(maxRadius: 30, backgroundImage: image);
                                    },
                                  )
                                  : CircleAvatar(
                                    maxRadius: 30,
                                    backgroundImage: const AssetImage("asset/icons/drawer/profile_pic.png"),
                                  ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.data?.fullName.toString() ?? "",
                                    style: whiteStyle.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(state.user.data?.mobile.toString() ?? "", style: whiteStyle),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),

                          Column(
                            children: [
                              const Divider(color: Colors.white),
                              const SizedBox(height: 2),
                              // 🔹 Notification Switch
                              FutureBuilder<bool>(
                                future: _getNotificationPref(),
                                builder: (context, snapshot) {
                                  final isSwitched = snapshot.data ?? false;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Show Notifications", style: TextStyle(color: Colors.white, fontSize: 14)),
                                      Switch(
                                        value: isSwitched,
                                        onChanged: (value) async {
                                          await _setNotificationPref(value);
                                          setState(() {}); // Refresh UI
                                        },
                                        activeColor: Colors.white, // Thumb color when ON
                                        activeTrackColor: greenColor.withOpacity(0.8), // Track color when ON
                                        inactiveThumbColor: Colors.white, // Thumb color when OFF
                                        inactiveTrackColor: Colors.grey.shade400, // Track color when OFF
                                        splashRadius: 30, // Ripple effect
                                        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                          if (states.contains(WidgetState.selected)) {
                                            return Colors.white; // White thumb when ON
                                          }
                                          return Colors.white; // White thumb when OFF
                                        }),
                                        trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
                                          return Colors.transparent; // Remove border
                                        }),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Tighter spacing
                                      ),
                                    ],
                                  );
                                },
                              ),

                              // if (!isExpired)
                              //   Container(
                              //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.max,
                              //       children: [
                              //         Expanded(
                              //           child: Container(
                              //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              //             decoration: BoxDecoration(
                              //               color: const Color(0xFFF6F9FC),
                              //               borderRadius: BorderRadius.circular(8),
                              //               boxShadow: onlyShadow(),
                              //             ),
                              //             child: Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children: [
                              //                 Image.asset("asset/icons/drawer/favourites.png", height: 20),
                              //                 const SizedBox(width: 5),
                              //                 Text(
                              //                   "${state.user.data?.sub_name ?? "Subscription"}",
                              //                   style: primaryStyle.copyWith(fontSize: 16, color: playColor),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         const SizedBox(width: 12),
                              //         Expanded(
                              //           child: Text(
                              //             translate("days_remaining", args: {"days": daysRemaining.toString()}),
                              //             overflow: TextOverflow.ellipsis,
                              //             style: primaryStyle.copyWith(fontSize: 14),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container(color: playColor, height: 150);
              },
            ),
            // Divider(color: Colors.white, height: 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                // _tile(
                //   leading: Image.asset("asset/icons/drawer/drawer_home.png", color: whiteColor, height: 30),
                //   title: Text(
                //     translate("drawer_home"),
                //     style: GoogleFonts.nunito(
                //       textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                //   onTap: () => Navigator.pop(context),
                // ),
                _tile(
                  leading: Image.asset("asset/icons/drawer/drawer_notification.png", color: whiteColor, height: 30),
                  title: Text(
                    translate("drawer_notification"),
                    style: GoogleFonts.nunito(
                      textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {},
                ),
                _tile(
                  leading: Image.asset("asset/icons/drawer/drawer_question.png", color: whiteColor, height: 30),
                  title: Text(
                    translate("drawer_change_language"),
                    style: GoogleFonts.nunito(
                      textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {},
                ),

                _tile(
                  leading: Image.asset("asset/icons/drawer/drawer_calendar.png", color: whiteColor, height: 30),
                  title: Text(
                    translate("drawer_transaction_history"),
                    style: GoogleFonts.nunito(
                      textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {},
                ),
                _tile(
                  leading: Image.asset("asset/icons/drawer/drawer_password.png", color: whiteColor, height: 30),
                  title: Text(
                    translate("drawer_change_password"),
                    style: GoogleFonts.nunito(textStyle: whiteStyle.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  onTap: () {},
                ),

                // BlocBuilder<SettingCubit, SettingState>(
                //   builder: (context, state) {
                //     return _tile(
                //       leading: Image.asset("asset/icons/drawer/drawer_share.png", color: whiteColor, height: 30),
                //       title: Text(
                //         translate("drawer_share"),
                //         style: GoogleFonts.nunito(
                //           textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //       onTap: () async {
                //         if (state is SettingLoadedState) {
                //           var shareUrl = state.model.data?[0].shareUrl;
                //           await Share.share("Download this application from website 100% trusted app 👇👇👇 $shareUrl");
                //         } else {
                //           await Share.share("Download this application from website 100% trusted app 👇👇👇 $url");
                //         }
                //       },
                //     );
                //   },
                // ),
                _tile(
                  leading: Image.asset("asset/icons/drawer/drawer_profile.png", color: whiteColor, height: 30),
                  title: Text(
                    translate("drawer_my_profile"),
                    style: GoogleFonts.nunito(
                      textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),

            _tile(
              leading: Icon(CupertinoIcons.collections, color: whiteColor, size: 20),
              title: Text(
                translate("terms_and_conditions"),
                style: GoogleFonts.nunito(
                  textStyle: blackStyle.copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {},
            ),
            /*Divider Here*/
            Divider(),
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              decoration: BoxDecoration(color: playColor, borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: whiteColor),
                    const SizedBox(width: 8),
                    Text(translate("drawer_logout"), style: GoogleFonts.nunito(textStyle: whiteStyle)),
                  ],
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    barrierDismissible: false, // Prevents closing on tap outside
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Header with Background Color
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: primaryColor, // Header background color
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: Text(
                                    translate("drawer_logout"),
                                    style: TextStyle(fontSize: 18, color: whiteColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              /// Icon
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.teal, width: 2),
                                ),
                                child: Icon(Icons.directions_run, size: 50, color: Colors.black),
                              ),
                              const SizedBox(height: 16),

                              /// Message
                              Text(
                                translate("logout_confirmation"),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),

                              /// Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  /// No Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor, // Button color
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      translate("no"),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  /// Yes Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () async {
                                      // Close Dialog
                                      // Perform Quit Action
                                      final removedKey = await pref.remove("key");
                                      final removedApiToken = await pref.remove(sharedPrefAPITokenKey);
                                      debugPrint("removed key: $removedKey, removedApiToken: $removedApiToken");
                                      context.read<LogOutCubit>().logOutApiCall();
                                    },
                                    child: Text(
                                      translate("yes"),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
