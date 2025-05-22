import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidEvent.dart';
import 'package:mobi_user/UI/MarketDashboard/AllPanaScreen.dart';
import 'package:mobi_user/UI/MarketDashboard/FamilyJodiScreen.dart';
import 'package:mobi_user/UI/MarketDashboard/FamilyPanaScreen.dart';
import 'package:mobi_user/UI/MarketDashboard/OddEvenScreen.dart';
import 'package:mobi_user/UI/MarketDashboard/RedJodiScreen.dart';
import 'package:mobi_user/UI/MarketDashboard/SpMotorScreen.dart';

import '../../../Bloc/MarketBloc/MarketModel.dart';
import '../../../Bloc/gameType/gameTypeBloc.dart';
import '../../../Bloc/gameType/gameTypeEvent.dart';
import '../../../Bloc/gameType/gameTypeState.dart';
import '../../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../../Utility/CustomFont.dart';
import '../../../Utility/MainColor.dart';
import '../../MarketDashboard/DoublePanaBulkScreen.dart';
import '../../MarketDashboard/DoublePanaScreen.dart';
import '../../MarketDashboard/DpMotorScreen.dart';
import '../../MarketDashboard/JodiDigitScreen.dart';
import '../../MarketDashboard/SingleDigitBulkScreen.dart';
import '../../MarketDashboard/SingleDigitScreen.dart';
import '../../MarketDashboard/SinglePanaBulkScreen.dart';
import '../../MarketDashboard/SinglePanaScreen.dart';
import '../../MarketDashboard/TripplePanaScreen.dart';
import 'bid_selector.dart';

class KalyanDashboard extends StatefulWidget {
  final int index;
  MarketModel market;
  final List<String>? shortCodes;

  KalyanDashboard({required this.market, required this.index, this.shortCodes});

  @override
  State<KalyanDashboard> createState() => _KalyanDashboardState();
}

class _KalyanDashboardState extends State<KalyanDashboard> {
  @override
  void initState() {
    BlocProvider.of<GameTypeBloc>(context).add(GameTypeEvent());
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Market Data:- ${widget.market.data?[widget.index].id}");
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        title: Text("${widget.market.data?[widget.index].marketName}"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white, width: 1.2)),
                backgroundColor: primaryColor,
              ),
              onPressed: () {},
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
      body: BlocBuilder<GameTypeBloc, GameTypeState>(
        builder: (context, state) {
          if (state is InitialGameTypeState) {
            BlocProvider.of<GameTypeBloc>(context).add(GameTypeEvent());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GameTypeNowState) {
            debugPrint(" Short Code: ${state.gameList.length}");
            final allGames = state.gameList;

            // Filtering logic
            final List<String>? shortCodes = widget.shortCodes;
            final filteredGames =
                shortCodes == null || shortCodes.isEmpty ? allGames : allGames.where((game) => shortCodes.contains(game.shortCode)).toList();
            final isOdd = filteredGames.length % 2 != 0;
            final remainingGames = isOdd ? filteredGames.sublist(1) : filteredGames;
            return filteredGames.isEmpty
                ? const Center(child: Text('No games available'))
                : ListView(
                  children: [
                    ///First Number Code
                    if (filteredGames.isNotEmpty && isOdd)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                            context.read<SettingCubit>().getSettingsApiCall();
                            print(filteredGames[0].shortCode);
                            if ((filteredGames[0].shortCode == "jd" ||
                                    filteredGames[0].shortCode == "hsd" ||
                                    filteredGames[0].shortCode == "fsd" ||
                                    filteredGames[0].shortCode! == "fj") &&
                                widget.market.data?[widget.index].marketStatus == "Close") {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("Can't play."), duration: const Duration(milliseconds: 1000)));
                            } else {
                              if (widget.market.data?[widget.index].marketOpenTime != "OPEN" &&
                                  (filteredGames[0].shortCode == "jd" ||
                                      filteredGames[0].shortCode == "hsd" ||
                                      filteredGames[0].shortCode == "fsd" ||
                                      filteredGames[0].shortCode! == "fj" ||
                                      filteredGames[0].shortCode! == "fp")) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text("Can't place the order."), duration: const Duration(milliseconds: 1000)));
                              } else {
                                if (filteredGames[0].shortCode! == "fpa" ||
                                    filteredGames[0].shortCode! == "dpa" ||
                                    filteredGames[0].shortCode! == "spa" ||
                                    filteredGames[0].shortCode! == "fj" ||
                                    filteredGames[0].shortCode! == "fp") {
                                  BlocProvider.of<BidBloc>(context).add(GetSuggestionsPittiesEvent(type: filteredGames[0].shortCode!, q: ""));
                                } else {
                                  BlocProvider.of<BidBloc>(context).add(InitialBidEvent());
                                }
                                //Todo: gameType means choose session by default open don't edit
                                //Todo: isOnlyClose market_open_status=> open or close
                                switch (filteredGames[0].shortCode.toString()) {
                                  case 'sd':
                                    //print("Status open or close => " + market.marketStatus.toString());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SingleDigitScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'sdb':
                                    //print("Status open or close => " + market.marketStatus.toString());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SingleDigitBulkScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.contain, image: AssetImage("asset/icons/${filteredGames[0].shortCode}.png")),
                            ),
                          ),
                        ),
                      ),

                    GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: remainingGames.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (context, _index) {
                        int itemIndex = _index;
                        return GestureDetector(
                          onTap: () {
                            context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                            context.read<SettingCubit>().getSettingsApiCall();
                            print(remainingGames[itemIndex].shortCode);
                            if ((remainingGames[itemIndex].shortCode == "jd" ||
                                    remainingGames[itemIndex].shortCode == "hsd" ||
                                    remainingGames[itemIndex].shortCode == "fsd" ||
                                    remainingGames[itemIndex].shortCode! == "fj") &&
                                widget.market.data?[widget.index].marketStatus == "Close") {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("Can't play."), duration: const Duration(milliseconds: 1000)));
                            } else {
                              if (widget.market.data?[widget.index].marketOpenTime != "OPEN" &&
                                  (remainingGames[itemIndex].shortCode == "jd" ||
                                      remainingGames[itemIndex].shortCode == "hsd" ||
                                      remainingGames[itemIndex].shortCode == "fsd" ||
                                      remainingGames[itemIndex].shortCode! == "fj" ||
                                      remainingGames[itemIndex].shortCode! == "fp")) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text("Can't place the order."), duration: const Duration(milliseconds: 1000)));
                              } else {
                                if (remainingGames[itemIndex].shortCode! == "fpa" ||
                                    remainingGames[itemIndex].shortCode! == "dpa" ||
                                    remainingGames[itemIndex].shortCode! == "spa" ||
                                    remainingGames[itemIndex].shortCode! == "fj" ||
                                    remainingGames[itemIndex].shortCode! == "fp") {
                                  BlocProvider.of<BidBloc>(
                                    context,
                                  ).add(GetSuggestionsPittiesEvent(type: remainingGames[itemIndex].shortCode!, q: ""));
                                } else {
                                  BlocProvider.of<BidBloc>(context).add(InitialBidEvent());
                                }
                                //Todo: gameType means choose session by default open don't edit
                                //Todo: isOnlyClose market_open_status=> open or close
                                switch (remainingGames[itemIndex].shortCode.toString()) {
                                  case 'sd':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SingleDigitScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'sdb':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SingleDigitBulkScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'jd':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => JodiDigitScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'sp':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SinglePanaScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'spb':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SinglePanaBulkScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'dp':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DoublePanaScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'dpb':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DoublePanaBulkScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'tp':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => TriplePanaScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'fp':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => FamilyPanaScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              gameType: "open",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'fj':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => FamilyJodiScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              gameType: "open",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'oe':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => OddEvenScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              gameType: "open",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'rj':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => RedJodiScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              gameType: "open",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                            ),
                                      ),
                                    );
                                    break;
                                  case "spm":
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SpMotorScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case "dpm":
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DpMotorScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'hsd':
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BidSelector(
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              market: widget.market,
                                              game: remainingGames[itemIndex],
                                              index: widget.index,
                                            ),
                                      ),
                                    );
                                    break;
                                  case 'fsd':
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BidSelector(
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              market: widget.market,
                                              game: remainingGames[itemIndex],
                                              index: widget.index,
                                            ),
                                      ),
                                    );
                                    break;
                                  default:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AllPanaScreen(
                                              marketName: widget.market.data?[widget.index].marketName.toString() ?? "",
                                              id: widget.market.data?[widget.index].id.toString() ?? "",
                                              isOnlyClose: widget.market.data?[widget.index].marketOpenTime.toString() == "CLOSED" ? true : false,
                                              gameType: "open",
                                            ),
                                      ),
                                    );
                                    break;
                                }
                              }
                            }
                            //https://mtadmin.online/junglesamrat_games/api/bid?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("asset/icons/${remainingGames[itemIndex].shortCode}.png"),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
          }
          return Container(child: Text("No Game Found"));
        },
      ),
    );
  }
}

//BackdropFilter(
//                       filter: widget.market.data?[widget.index].marketStatusToday != "Open" &&
//                               (state.gameList[itemIndex].shortCode == "jd" ||
//                                   state.gameList[itemIndex].shortCode == "hsd" ||
//                                   state.gameList[itemIndex].shortCode == "fsd")
//                           ? ImageFilter.blur(sigmaX: .44, sigmaY: .44)
//                           : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
