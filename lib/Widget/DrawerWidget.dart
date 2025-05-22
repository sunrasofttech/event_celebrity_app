import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketCubit.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketState.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/UI/ChangePassScreen.dart';
import 'package:mobi_user/UI/FundHistory.dart';
import 'package:mobi_user/UI/GameRateScreen.dart';
import 'package:mobi_user/UI/NoticeBoardScreen.dart';
import 'package:mobi_user/UI/NotificationScreen.dart';
import 'package:mobi_user/UI/Subscription/SubscriptionScreen.dart';
import 'package:mobi_user/UI/UI_new/SelectLanguageScreen.dart';
import 'package:mobi_user/UI/UpdateProfileScreen.dart';
import 'package:mobi_user/UI/WinHistoryScreen.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:share_plus/share_plus.dart';

import '../Bloc/LogOutCubit/LogOutCubit.dart';
import '../UI/BiddingHistory.dart';
import '../UI/UI_new/WelcomeScreen.dart';
import '../Utility/CustomFont.dart';
import '../Utility/const.dart';
import '../main.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: BlocBuilder<MarketCubit, MarketState>(
        builder: (context, marketState) {
          return SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                  builder: (context, state) {
                    if (state is UserProfileFetchedState) {
                      final expireAtStr = state.user.data?.subscription_expires_at.toString();
                      int daysRemaining = 0;
                      bool isExpired = true;

                      if (expireAtStr != null && expireAtStr.isNotEmpty && expireAtStr != "null") {
                        try {
                          final expireDate = DateTime.parse(expireAtStr).toLocal();
                          final today = DateTime.now();

                          daysRemaining = expireDate.difference(today).inDays;
                          isExpired = expireDate.isBefore(today);
                        } catch (e) {
                          debugPrint("Date parse error: $e");
                        }
                      }

                      log("---->>> isExpired:- $isExpired, day remaining $daysRemaining");
                      return Container(
                        margin: const EdgeInsets.only(top: 25, left: 6, right: 6, bottom: 6),
                        // padding: EdgeInsets.only(top: 50),
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF9000), Color(0xFFFFD000)],
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
                                  state.user.data?.imagePath?.isNotEmpty ?? false
                                      ? CachedNetworkImage(
                                        imageUrl: "${Constants.baseUrl}${state.user.data?.imagePath}",
                                        errorWidget: (context, _, child) {
                                          return CircleAvatar(maxRadius: 30, backgroundImage: const AssetImage("asset/icons/drawer/profile_pic.png"));
                                        },
                                        imageBuilder: (context, image) {
                                          return CircleAvatar(maxRadius: 30, backgroundImage: image);
                                        },
                                      )
                                      : CircleAvatar(maxRadius: 30, backgroundImage: const AssetImage("asset/icons/drawer/profile_pic.png")),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(state.user.data?.name.toString() ?? "", style: whiteStyle.copyWith(fontWeight: FontWeight.w600)),
                                      Text(state.user.data?.mobile.toString() ?? "", style: whiteStyle),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Divider(color: Colors.white),
                              const SizedBox(height: 2),
                              if (!isExpired)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF6F9FC),
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: onlyShadow(),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset("asset/icons/drawer/favourites.png", height: 20),
                                              const SizedBox(width: 5),
                                              Text(
                                                "${state.user.data?.sub_name ?? "Subscription"}",
                                                style: primaryStyle.copyWith(fontSize: 16, color: playColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          translate("days_remaining", args: {"days": daysRemaining.toString()}),
                                          overflow: TextOverflow.ellipsis,
                                          style: primaryStyle.copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              if (isExpired)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF6F9FC),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
                                      },
                                      child: Text(translate("subscribe"), style: TextStyle(color: playColor)),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          translate("extra_benefits"),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
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
                (marketState is MarketUnAuthorizedState || marketState is MarketLoadingState)
                    ? const SizedBox()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_home.png", height: 30),
                          title: Text(
                            translate("drawer_home"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_profile.png", height: 30),
                          title: Text(
                            translate("drawer_my_profile"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_calendar.png", height: 30),
                          title: Text(
                            translate("drawer_bid_history"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BiddingHistory()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_calendar.png", height: 30),
                          title: Text(
                            translate("drawer_transaction_history"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FundHistory()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_calendar.png", height: 30),
                          title: Text(
                            translate("drawer_win_history"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const WinHistoryScreen()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_notification.png", height: 30),
                          title: Text(
                            translate("drawer_notification"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_question.png", height: 30),
                          title: Text(
                            translate("drawer_game_rates"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const GameRateScreen()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_question.png", height: 30),
                          title: Text(
                            translate("drawer_notice_board"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeBoardScreen()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_question.png", height: 30),
                          title: Text(
                            translate("drawer_change_language"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLanguageScreen(fromDrawer: true)));
                          },
                        ),
                        ListTile(
                          leading: Image.asset("asset/icons/drawer/drawer_password.png", height: 30),
                          title: Text(
                            translate("drawer_change_password"),
                            style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassScreen()));
                          },
                        ),
                        BlocBuilder<SettingCubit, SettingState>(
                          builder: (context, state) {
                            return ListTile(
                              leading: Image.asset("asset/icons/drawer/drawer_share.png", height: 30),
                              title: Text(
                                translate("drawer_share"),
                                style: GoogleFonts.nunito(textStyle: blackStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                              ),
                              onTap: () async {
                                if (state is SettingLoadedState) {
                                  var shareUrl = state.model.data?[0].shareUrl;
                                  await Share.share("Download this application from website 100% trusted app 👇👇👇 $shareUrl");
                                } else {
                                  await Share.share("Download this application from website 100% trusted app 👇👇👇 $url");
                                }
                              },
                            );
                          },
                        ),
                      ],
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
                                      color: Colors.amber, // Header background color
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    child: Center(
                                      child: Text(translate("drawer_logout"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  /// Icon
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.teal, width: 2)),
                                    child: Icon(Icons.directions_run, size: 50, color: Colors.black),
                                  ),
                                  const SizedBox(height: 16),

                                  /// Message
                                  Text(
                                    translate("logout_confirmation"),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                                          backgroundColor: Colors.amber, // Button color
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(translate("no"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      ),

                                      /// Yes Button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
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
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => GetStartedScreen()),
                                            (route) => false,
                                          );
                                        },
                                        child: Text(translate("yes"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: Text("Are you sure you want to logout?"),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: Text("Cancel"),
                      //         ),
                      //         TextButton(
                      //           onPressed: () async {
                      //             final removedKey = await pref.remove("key");
                      //             final removedApiToken = await pref.remove(sharedPrefAPITokenKey);
                      //             debugPrint("removed key: $removedKey, removedApiToken: $removedApiToken");
                      //             context.read<LogOutCubit>().logOutApiCall();
                      //             Navigator.pushAndRemoveUntil(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => GetStartedScreen(),
                      //               ),
                      //               (route) => false,
                      //             );
                      //           },
                      //           child: Text(translate("ok"),
                      //         )
                      //       ],
                      //     );
                      //   },
                      // );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
