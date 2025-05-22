import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/UI/KalyanDashBoard/bet/bid_form.dart';
import 'package:mobi_user/UI/KalyanDashBoard/bet/play_bid.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Bloc/MarketBloc/MarketModel.dart';
import '../../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../../Utility/CustomFont.dart';
import '../../../Utility/MainColor.dart';
import '../../../model/gameType.dart';

class BidSelector extends StatefulWidget {
  MarketModel market;
  GameType game;
  int index;
  String id;
  BidSelector({super.key, required this.id, required this.game, required this.market, required this.index});

  @override
  State<BidSelector> createState() => _BidSelectorState();
}

class _BidSelectorState extends State<BidSelector> {
  _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Bid placed'),
          content: SingleChildScrollView(child: ListBody(children: const <Widget>[Text('Your bid has been placed successfully.')])),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
  // --- Button Widget --- //

  bool isOnlyClose = false;
  String uid = "";
  fetchData() async {
    uid = await SharedPreferences.getInstance().toString();

    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
    if (widget.market.data?[widget.index].marketStatusToday == "Closed") {
      isOnlyClose = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        title: Text(widget.game.name.toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white, width: 1.2)),
                backgroundColor: maroonColor,
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
              icon: Text("💳"),
            ),
          ),
        ],
      ),
      body: BlocListener<BidBloc, BidState>(
        listener: (context, state) {
          if (state is BidNowPlacedState) {
            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) {
                  final failureMessage = failure.failureMessage;
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(failureMessage),
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
                },
                (right) async {
                  Navigator.pop(context);
                  await _showAlertDialog();
                },
              ),
            );
          }
        },
        child: BlocBuilder<BidBloc, BidState>(
          builder: (context, state) {
            if (state is InitialBidState) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: BidForm(
                  index: widget.index,
                  isOnlyClose: isOnlyClose,
                  statusCode: widget.game.shortCode ?? "",
                  gameType: widget.game,
                  market: widget.market,
                ),
              );
            }
            if (state is BidNowState) {
              return PlayBid(
                index: widget.index,
                id: widget.market.data?[widget.index].id?.toString() ?? "",
                isOnlyClose: isOnlyClose,
                code: widget.game.shortCode ?? "",
                state: state,
                game: widget.game,
                market: widget.market,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
