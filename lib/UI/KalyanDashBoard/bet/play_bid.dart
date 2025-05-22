import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketCubit.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidEvent.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/UI/KalyanDashBoard/bet/bidTable.dart';
import 'package:mobi_user/UI/KalyanDashBoard/bet/bid_form.dart';
import 'package:mobi_user/Widget/ButtonWidget.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;
import 'package:mobi_user/model/gameType.dart';

import '../../../Bloc/BannerBloc/BannerCubit.dart';
import '../../../Bloc/MarketBloc/MarketModel.dart';
import '../../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../../Utility/CustomFont.dart';
import '../../../Utility/MainColor.dart';
import '../../../Utility/ProgressIndicator.dart';
import '../../../main.dart';

class PlayBid extends StatefulWidget {
  String code;
  BidNowState state;
  MarketModel market;
  GameType game;
  String id;
  int index;
  bool isOnlyClose;
  PlayBid({
    super.key,
    required this.id,
    required this.code,
    required this.index,
    required this.state,
    required this.market,
    required this.game,
    required this.isOnlyClose,
  });

  @override
  State<PlayBid> createState() => _PlayBidState();
}

class _PlayBidState extends State<PlayBid> {
  bool loading = false;
  double total = 0;

  @override
  Widget build(BuildContext context) {
    /*  print("Pana ${state.bidList.map((e) => e["pana"]).toList()}");
    print("BidList ${state.bidList.map((e) => e["digit"]).toList()}");*/
    return BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
      builder: (context, state) {
        return BlocConsumer<BidBloc, BidState>(
          listener: (context, bidState) {
            debugPrint("[PLAY BID] Bid State:- $bidState");
            if (bidState is BidNowPlacedState) {
              setState(() {
                loading = false;
              });
            }
          },
          builder: (context, bidState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                // height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    BidForm(
                      index: widget.index,
                      isOnlyClose: widget.isOnlyClose,
                      statusCode: widget.code,
                      bidState: widget.state,
                      gameType: widget.game,
                      market: widget.market,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BidTable(code: widget.code, state: widget.state),
                    SizedBox(
                      height: 20,
                    ),
                    (bidState is BidNowState)
                        ? SizedBox(
                            width: 300,
                            child: ButtonWidget(
                              primaryColor: maroonColor,
                              title: loading ? CustomProgressIndicator() : Text("Place Bid", style: whiteStyle),
                              callback: () async {
                                if (loading) return;
                                if (state is UserProfileFetchedState) {
                                  if (double.parse(state.user.data?.balance.toString() ?? "0").truncate() >=
                                      double.parse(bidState.total.toString()).truncate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    List<bid_model.Datum> data = [];
                                    for (int i = 0; i < widget.state.bidList.length; i++) {
                                      data.add(
                                        bid_model.Datum(
                                          pana: widget.state.bidList[i].pana,
                                          digit: widget.state.bidList[i].digit,
                                          points: widget.state.bidList[i].points,
                                          session: widget.state.bidList[i].session,
                                          game: widget.code ?? "",
                                          marketId: widget.id,
                                        ),
                                      );
                                    }
                                    BlocProvider.of<BidBloc>(context).add(
                                      GetBidEvent(
                                        id: widget.id,
                                        data: data,
                                        // type: state.bidList[i].session,
                                        // digit: state.bidList[i].digit,
                                        // points: state.bidList[i].points,
                                        // /*  marketData: this.market,
                                        // gameDetails: this.game,*/
                                        // mType: code ?? "",
                                        // index: i,
                                        // pana1: state.bidList[i].pana,
                                      ),
                                    );
                                    String uid = await pref.getString("key").toString();
                                    context.read<MarketCubit>().getMarkets(uid);
                                    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                                    context.read<BannerCubit>().fetchBanner();
                                  }
                                }

                                FocusScope.of(context).unfocus();
                              },
                            ),
                          )
                        : SizedBox(
                            width: 300,
                            child: ButtonWidget(
                              primaryColor: greyColor,
                              title: Text("Place Bid", style: whiteStyle),
                              callback: () async {},
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
