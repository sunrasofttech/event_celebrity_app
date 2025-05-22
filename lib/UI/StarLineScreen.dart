import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:marquee/marquee.dart';

import '../Bloc/HomeTextBloc/HomeTextBloc.dart';
import '../Bloc/HomeTextBloc/HomeTextState.dart';
import '../Bloc/MarketBloc/MarketCubit.dart';
import '../Bloc/MarketBloc/MarketState.dart';
import '../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';
import '../Utility/const.dart';
import '../main.dart';
import 'AddFundScreen.dart';
import 'KalyanDashBoard/bet/kalyan_dashboard_screen.dart';
import 'UnAuthorizedScreen.dart';
import 'WithDrawScreen.dart';

class StarLineScreen extends StatefulWidget {
  const StarLineScreen({super.key});

  @override
  State<StarLineScreen> createState() => _StarLineScreenState();
}

class _StarLineScreenState extends State<StarLineScreen> with WidgetsBindingObserver {
  bool fetchDataCalled = false;

  @override
  void initState() {
    context.read<MarketCubit>().emitLoading();
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (ModalRoute.of(context)?.isCurrent == true) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.resumed) {
        fetchData();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)?.isCurrent == true) {
      fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant StarLineScreen oldWidget) {
    if (ModalRoute.of(context)?.isCurrent == true) {
      fetchData();
    }
    super.didUpdateWidget(oldWidget);
  }

  fetchData() async {
    debugPrint("-------><><><><><----------");
    fetchDataCalled = true;
    String uid = await pref.getString("key").toString();
    context.read<MarketCubit>().getMarkets(uid, marketType: "starline");
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
  }

  onPlayFunction(MarketLoadedState marketState, int index) {
    if (marketState.market.data?[index].marketStatusToday == "close") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(translate("holiday_message")),
            content: Text(translate("cant_place_bid")),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(translate("ok")),
              ),
            ],
          );
        },
      );
      return;
    }

    if (marketState.market.data?[index].marketStatus == "OPEN") {
      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KalyanDashboard(market: marketState.market, index: index, shortCodes: ["sd", "sp", "dp", "tp"])),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translate("holiday_message")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(translate("ok")),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        String uid = await pref.getString("key").toString();
        context.read<MarketCubit>().emitLoading();
        context.read<MarketCubit>().getMarkets(uid);
        return true;
      },
      child: BlocBuilder<MarketCubit, MarketState>(
        builder: (context, marketState) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(decoration: blueBoxDecoration()),
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: whiteColor),
              title: Text(translate("dashboard.starline"), style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor)),
              actions: [
                (marketState is MarketUnAuthorizedState || marketState is MarketLoadingState)
                    ? const SizedBox()
                    : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: whiteColor, width: 1.2)),
                          backgroundColor: maroonColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceIn)),
                                  child: const AddFundScreen(),
                                );
                              },
                            ),
                          );
                        },
                        label: BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                          builder: (context, state) {
                            if (state is UserProfileFetchedState) {
                              return Text("${state.user.data?.balance ?? "0"}", style: whiteStyle);
                            }
                            return Text("0", style: whiteStyle);
                          },
                        ),
                        icon: Icon(Icons.account_balance_wallet, color: whiteColor),
                      ),
                    ),
              ],
            ),
            body: BlocConsumer<MarketCubit, MarketState>(
              listener: (context, state) async {
                if (state is MarketLoadingState || state is MarketLoadedState || state is MarketErrorState) {
                  fetchDataCalled = false;
                }
              },
              builder: (context, marketState) {
                if (marketState is MarketUnAuthorizedState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      fetchData();
                    },
                    child: UnAuthorizedScreen(),
                  );
                }
                if (marketState is MarketLoadingState) {
                  return Center(child: CircularProgressIndicator(color: blackColor));
                }

                if (marketState is MarketLoadedState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<MarketCubit>().emitLoading();
                      fetchData();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 35,
                            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              // color: playColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: BlocBuilder<HomeTextBloc, HomeTextState>(
                              builder: (context, state) {
                                if (state is HomeTextLoadedState) {
                                  return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Marquee(
                                      text:
                                          "${state.model != null && state.model.homeText != null && state.model.homeText!.isNotEmpty ? state.model.homeText! : "$appName Welcomes You"}",
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      blankSpace: 10,
                                      velocity: 100,
                                      numberOfRounds: 100,
                                      pauseAfterRound: Duration(seconds: 1),
                                      startPadding: 10,
                                      accelerationDuration: Duration(seconds: 1),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration: Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                      style: blackStyle.copyWith(fontSize: 14, color: primaryColor),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),

                          ///Banner Image
                          // Container(
                          //   color: Colors.black,
                          //   child: Image.asset(
                          //     "asset/icons/front-img.png",
                          //     height: 120,
                          //     width: MediaQuery.of(context).size.width,
                          //     fit: BoxFit.fitHeight,
                          //   ),
                          // ),
                          const SizedBox(height: 10),

                          ///Add and withdraw button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Add Money Button
                                shadowWidget(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF6F9FC),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFundScreen()));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'asset/icons/add_wallet.png', // Replace with your green icon asset
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          translate("add_money"),
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Withdraw Button
                                shadowWidget(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF6F9FC),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WithdrawalScreen()));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'asset/icons/withdraw_wallet.png', // Replace with your red icon asset
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          translate("withdraw"),
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView.builder(
                              itemCount: marketState.market.data?.length ?? 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isPlayPressed = false;
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  // decoration: BoxDecoration(color: whiteColor),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Color(0x40B3B3B3), width: 0.5),
                                    boxShadow: [
                                      BoxShadow(color: Colors.white, blurRadius: 6, offset: const Offset(0, 3)),
                                      BoxShadow(
                                        color: const Color(0x40494949), // 25% opacity black
                                        offset: const Offset(6, 6),
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${marketState.market.data?[index].opencloseTime}",
                                                  style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                      ? "Closed for Today"
                                                      : marketState.market.data?[index].marketStatus == "OPEN"
                                                      ? "Running For Today"
                                                      : "Closed for Today",
                                                  style:
                                                      marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                          ? redStyle.copyWith(fontSize: 10)
                                                          : marketState.market.data?[index].marketStatus == "OPEN"
                                                          ? greenStyle.copyWith(fontSize: 10)
                                                          : redStyle.copyWith(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFF8C00),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0x59EDBC60), // 25% opacity black
                                                    offset: const Offset(6, 6),
                                                    blurRadius: 15,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                "${marketState.market.data?[index].result}",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                StatefulBuilder(
                                                  builder: (context, setInnerState) {
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTapDown: (_) async {
                                                            setInnerState(() {
                                                              isPlayPressed = true;
                                                            });
                                                          },
                                                          onTapUp: (_) async {
                                                            setInnerState(() {
                                                              isPlayPressed = false;
                                                            });
                                                            // Your button action
                                                            log("Play Game tapped for index $index");
                                                            await onPlayFunction(marketState, index);
                                                          },
                                                          onTapCancel: () {
                                                            setInnerState(() {
                                                              isPlayPressed = false;
                                                            });
                                                          },
                                                          child: AnimatedContainer(
                                                            duration: Duration(milliseconds: 100),
                                                            padding: const EdgeInsets.all(6),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              shape: BoxShape.circle,

                                                              boxShadow:
                                                                  isPlayPressed
                                                                      ? [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(3, 1))]
                                                                      : [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(6, 2))],
                                                            ),
                                                            child:
                                                                marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                                    ? disabledCircleIcon(Icons.play_arrow)
                                                                    : marketState.market.data?[index].marketStatus == "OPEN"
                                                                    ? circleIcon(Icons.play_arrow)
                                                                    : disabledCircleIcon(Icons.play_arrow),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                const SizedBox(height: 4),
                                                Text(translate("dashboard.play_game"), style: TextStyle(fontSize: 12, color: Color(0xFF003366))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const Divider(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
