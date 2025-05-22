import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/model/BidListModel.dart';

import 'bidEvent.dart';
import 'bidRepository.dart';
import 'bidState.dart';

class BidBloc extends Bloc<BidEvents, BidState> {
  BidBloc() : super(InitialBidState(bidList: [])) {
    List<BidListModel> bidList = [];
    String total = "0";
    List<String> suggestionList = [];
    String selectedPana = "";
    getTotal() {
      int value = 0;
      try {
        for (int i = 0; i < bidList.length; i++) {
          value = value + int.parse(bidList[i].points);
        }
      } catch (err) {}

      total = value.toString();
      return;
    }

    on<InitialBidEvent>((event, emit) async {
      bidList.clear();

      emit(InitialBidState(bidList: bidList));
    });
    on<GetSuggestionsPittiesEvent>((event, emit) async {
      var data = await BidRepository().suggestPatties(
        type: event.type,
        q: event.q,
      );

      data.fold(
          (left) => emit(
                BidNowState(
                  apiFailureOrSuccessOption: optionOf(data),
                  bidList: bidList,
                  total: total,
                  suggestionList: suggestionList,
                ),
              ), (right) async {
        print(right);
        suggestionList = right;
        selectedPana = right[0];
        emit(
          PattiState(
              apiFailureOrSuccessOption: none(),
              bidList: bidList,
              total: total,
              suggestionList: suggestionList,
              pitties: "",
              selectedPana: selectedPana),
        );
      });
    });
    on<GetPittiesEvent>(
      (event, emit) async {
        selectedPana = event.pana;
        var data = await BidRepository().getPitties(
          type: event.type,
          pana: event.pana,
        );

        data.fold(
          (left) => emit(
            PattiState(
                apiFailureOrSuccessOption: optionOf(data),
                bidList: bidList,
                total: total,
                suggestionList: suggestionList,
                pitties: "",
                selectedPana: selectedPana),
          ),
          (right) async {
            print(right);
            emit(
              PattiState(
                apiFailureOrSuccessOption: none(),
                bidList: bidList,
                total: total,
                suggestionList: suggestionList,
                pitties: right,
                selectedPana: selectedPana,
              ),
            );
          },
        );
      },
    );
    on<GetBidEvent>(
      (event, emit) async {
        log("Market Id => ${event.id} Pana=>${event.pana1}");
        var data = await BidRepository().placeBid(
          marketId: event.id ?? "",
          points: event.points ?? "",
          session: event.session ?? "",
          digit: event.digit ?? "",
          game: event.game ?? "",
          pana1: event.pana1 ?? "",
          datum: event.data,
        );
        print("Place Bid Data $data");

        emit(InitialBidState(bidList: bidList));
        data.fold(
          (left) => emit(
            BidNowPlacedState(
              apiFailureOrSuccessOption: optionOf(data),
              bidList: bidList,
              total: total,
              suggestionList: [],
            ),
          ),
          (right) {
            print("PLACE BID RIGHT " + right.toString());
            /* if (event.index == bidList.length - 1) {
            bidList.clear();
          }
          bidList.removeAt(event.index);*/
            getTotal();
            emit(
              BidNowPlacedState(
                apiFailureOrSuccessOption: optionOf(data),
                bidList: bidList,
                total: total,
                suggestionList: [],
              ),
            );
          },
        );
      },
    );
    on<GetSPDPTPBidEvent>(
      (event, emit) async {
        log("Market Id => ${event.id} Pana=>${event.pana1}");
        var data = await BidRepository().placeBidForSPDPTP(
          marketId: event.id ?? "",
          points: event.points ?? "",
          session: event.session ?? "",
          digit: event.digit ?? "",
          game: event.game ?? "",
          pana1: event.pana1 ?? "",
          mType: event.mType ?? "",
          datum: event.data,
        );
        print("Place SPDPTP Bid Data $data");

        emit(InitialBidState(bidList: bidList));
        data.fold(
          (left) => emit(
            BidNowPlacedState(
              apiFailureOrSuccessOption: optionOf(data),
              bidList: bidList,
              total: total,
              suggestionList: [],
            ),
          ),
          (right) {
            print("PLACE BID RIGHT " + right.toString());
            /* if (event.index == bidList.length - 1) {
            bidList.clear();
          }
          bidList.removeAt(event.index);*/
            getTotal();
            emit(
              BidNowPlacedState(
                apiFailureOrSuccessOption: optionOf(data),
                bidList: bidList,
                total: total,
                suggestionList: [],
              ),
            );
          },
        );
      },
    );
    /*on<GetBidEvent>(
      (event, emit) async {
        String points = "", digit = "";
        String status = "";
        */
    /* for (int i = 0; i < bidList.length; i++) {
          print(bidList[0]);
          bool check = (i + 1) == bidList.length;
          print(check);
          points = "$points${bidList[i]["points"]}${!check ? "," : ""}";

          digit = "$digit${bidList[i]["digit"]}${!check ? "," : ""}";

          status = "$status${bidList[i]["status"]}${!check ? "," : ""}";
        }*/
    /*
        print(points);
        print(status);
        */
    /* var data = await BidRepository().placeBid(
          marketId: event.marketData.id ?? "",
          // bidList[event.index]["digit"],
          mType: event.mType,
          model: bidList,
        );*/
    /*
        var data = await BidRepository().placeBid(
          marketId: event.id ?? "",
          points: event.points, // bidList[event.index]["points"] ?? "",
          type: event.type,
          */
    /* bidList[event.index]["status"]*/ /*
          digit: event.digit, //bidList[event.index]["digit"],
          mType: event.mType,
          pana1: event.pana1,
        );
        emit(InitialBidState(bidList: bidList));
        data.fold(
            (left) => emit(
                  BidNowState(
                    apiFailureOrSuccessOption: optionOf(data),
                    bidList: bidList,
                    total: total,
                    suggestionList: suggestionList,
                  ),
                ), (right) {
          print(right);
          bidList.clear();
          // bidList.removeAt(event.index);
          getTotal();

          emit(
            BidNowState(
              apiFailureOrSuccessOption: optionOf(data),
              bidList: bidList,
              total: total,
              suggestionList: suggestionList,
            ),
          );
        });
      },
    );*/

    /*  on<StarLinePlaceBidEvent>((event, emit) async {
      var data = await BidRepository()
          .placeStarLineBid(points: event.points, starLineId: event.id, digit: event.digit, mType: event.mtype);
      data.fold(
          (left) => emit(
                BidNowState(
                  apiFailureOrSuccessOption: optionOf(data),
                  bidList: bidList,
                  total: total,
                  suggestionList: [],
                ),
              ), (right) {
        print(right);
        if (event.index == bidList.length - 1) {
          bidList.clear();
        }
        // bidList.removeAt(event.index);
        getTotal();
        emit(
          BidNowState(
            apiFailureOrSuccessOption: optionOf(data),
            bidList: bidList,
            total: total,
            suggestionList: [],
          ),
        );
      });
    });*/
    /*on<PlaceSangamEvent>(
      (event, emit) async {
        var data = await BidRepository().placeBid(
          marketId: event.marketData.id ?? "",
         */
    /* points: event.points,*/
    /*
         */
    /* type: event.gameStatus,
         // bidList[event.index]["status"],
          digit: event.digit,*/
    /*
          mType: event.mType,
          model: event.
          */
    /*pana1: event.pana1,*/
    /*
        );

        emit(InitialBidState(bidList: bidList));
        data.fold(
            (left) => emit(
                  BidNowState(
                    apiFailureOrSuccessOption: optionOf(data),
                    bidList: bidList,
                    total: total,
                    suggestionList: suggestionList,
                  ),
                ), (right) {
          print(right);
          if (event.index == bidList.length - 1) {
            bidList.clear();
          }

          // bidList.removeAt(event.index);
          getTotal();

          emit(
            BidNowState(
              apiFailureOrSuccessOption: optionOf(data),
              bidList: bidList,
              total: total,
              suggestionList: suggestionList,
            ),
          );
        });
      },
    );*/
    on<PlaceBudEventerForPitties>(
      (event, emit) async {
        var data = await BidRepository().placeBidForPatti(
          marketId: event.marketId ?? "",
          points: event.points,
          type: event.gameStatus,
          // bidList[event.index]["status"],
          mType: event.mType,
          pana1: event.pana1,
        );
        bidList.clear();
        emit(InitialBidState(bidList: bidList));
        data.fold(
            (left) => emit(
                  BidNowState(
                    apiFailureOrSuccessOption: optionOf(data),
                    bidList: bidList,
                    total: total,
                    suggestionList: suggestionList,
                  ),
                ), (right) {
          print(right);

          emit(
            PattiState(
              apiFailureOrSuccessOption: optionOf(data),
              bidList: bidList,
              total: total,
              suggestionList: suggestionList,
              pitties: "",
              selectedPana: selectedPana,
            ),
          );
        });
      },
    );

    on<AddBidEvent>(
      (event, emit) async {
        bidList.add(BidListModel(event.digit, event.price, event.pana, event.status, event.mType ?? ""));

        await getTotal();

        emit(
          BidNowState(
            apiFailureOrSuccessOption: none(),
            bidList: bidList,
            total: total,
            suggestionList: suggestionList,
          ),
        );
      },
    );
    on<DeleteBid>(
      (event, emit) async {
        emit(InitialBidState(bidList: bidList));

        await bidList.removeAt(event.index);
        await getTotal();

        if (bidList.isEmpty) {
          emit(InitialBidState(bidList: bidList));
          return;
        } else {
          emit(
            BidNowState(
              apiFailureOrSuccessOption: none(),
              bidList: bidList,
              total: total,
              suggestionList: suggestionList,
            ),
          );
        }
      },
    );
  }
}
