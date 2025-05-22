import 'dart:io';

// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketCubit.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketState.dart';
import 'package:mobi_user/UI/BiddingHistory.dart';
import 'package:mobi_user/UI/DashboardScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/SettingBloc/SettingCubit.dart';
import '../Bloc/SettingBloc/SettingState.dart';
import '../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../Utility/MainColor.dart';
import '../Utility/custom_nav_bar/my_custom_bar.dart';
import '../Utility/glowing_whatsapp_button.dart';
import 'FundHistory.dart';
import 'FundOptions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget currentPage = SizedBox();
  List<Widget> pages = [];
  int currentIndex = 2;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      setState(() {
        pages = [BiddingHistory(), FundHistory(), DashBoardScreen(), FundOptionScreen(), const SizedBox()];
        currentPage = pages[2];
      });
    });
    super.initState();
  }

  openWhatsapp(num) async {
    var state = context.read<UserProfileBlocBloc>().state;
    if (state is UserProfileFetchedState) {
      var number = num.toString().replaceAll("+91", "");
      var whatsapp = "+91$number";
      var whatsappURl_android =
          "whatsapp://send?phone=" + whatsapp + "&text=Username - ${state.user.data?.name} \n Mobile - ${state.user.data?.mobile}";
      var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("Username - ${state.user.data?.name} \n Mobile - ${state.user.data?.mobile}")}";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
          await launchUrl(Uri.parse(whatsappURL_ios));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        }
      } else {
        // android , web
        if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
          await launchUrl((Uri.parse(whatsappURl_android)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        }
      }
    }
  }

  List _iconList = [Icons.stacked_line_chart_outlined, Icons.calendar_month, Icons.monetization_on_rounded, FontAwesomeIcons.telegram];

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, marketState) {
        return Scaffold(
          body: currentPage,
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),

              child: Builder(
                builder: (context) {
                  // if (marketState is MarketUnAuthorizedState || marketState is MarketLoadingState) {
                  //   return const SizedBox();
                  // }
                  return BlocBuilder<SettingCubit, SettingState>(
                    builder: (context, state) {
                      return CurvedNavigationBar(
                        backgroundColor: Colors.transparent,
                        color: primaryColor,
                        buttonBackgroundColor: playColor,
                        index: currentIndex,
                        iconPadding: 12,
                        onTap:
                            (i) => setState(() {
                              if (i == 4) {
                                if (state is SettingLoadedState) {
                                  openWhatsapp(state.model.data?[0].whatsappNo);
                                }
                                return;
                              }
                              currentIndex = i;
                              currentPage = pages[currentIndex];
                            }),
                        items: [
                          CurvedNavigationBarItem(
                            child: Image.asset("asset/icons/bid_icon.png", height: 20, width: 20),
                            label: translate("bottom_nav.my_bids"),
                            labelStyle: TextStyle(color: currentIndex == 0 ? playColor : Colors.white),
                          ),
                          CurvedNavigationBarItem(
                            child: Image.asset("asset/icons/transaction_history.png", height: 20, width: 20),
                            label: translate("bottom_nav.passbook"),
                            labelStyle: TextStyle(color: currentIndex == 1 ? playColor : Colors.white),
                          ),
                          CurvedNavigationBarItem(
                            child: Image.asset("asset/icons/home_icon.png", height: 20, width: 20),
                            label: translate("bottom_nav.home"),
                            labelStyle: TextStyle(color: currentIndex == 2 ? playColor : Colors.white),
                          ),
                          CurvedNavigationBarItem(
                            child: Image.asset("asset/icons/add_funds.png", height: 20, width: 20),
                            label: translate("bottom_nav.funds"),
                            labelStyle: TextStyle(color: currentIndex == 3 ? playColor : Colors.white),
                          ),
                          CurvedNavigationBarItem(
                            child: GlowingWhatsAppButton(),
                            label: translate("bottom_nav.support"),
                            labelStyle: TextStyle(color: currentIndex == 4 ? playColor : Colors.white),
                          ),
                        ],

                        //other params
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
