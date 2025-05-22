import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/MarketBloc/marketModel.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;
import 'package:mobi_user/model/gameType.dart';

abstract class BidEvents extends Equatable {}

/*class GetBidEvent extends BidEvents {
  MarketModel marketData;
  GameType gameDetails;
  String mType;
  */ /* List<BidListModel> model;*/ /*
  */ /* String pana1;*/ /*
  GetBidEvent({
    required this.marketData,
    required this.gameDetails,
    required this.mType,
    */ /*  required this.model,*/ /*
    */ /*  required this.pana1*/ /*
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        marketData,
        gameDetails,
        mType,
        model,
        */ /*  pana1,*/ /*
      ];
}*/
class GetBidEvent extends BidEvents {
  /* MarketModel marketData;
  GameType gameDetails;*/
  final int? index;
  String? game;
  String? id;
  List<bid_model.Datum> data;
  String? points;
  String? session;
  String? digit;
  String? pana1;

  GetBidEvent({
    /*required this.marketData,
      required this.gameDetails,*/
    this.game,
    this.index,
    this.digit,
    required this.data,
    this.points,
    this.session,
    this.id,
    this.pana1,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        /*  marketData,
        gameDetails,*/
        game,
        index,
        digit,
        points,
        session,
        id,
        pana1,
      ];
}

class GetSPDPTPBidEvent extends BidEvents {
  /* MarketModel marketData;
  GameType gameDetails;*/
  final int? index;
  String? game;
  String? id;
  List<bid_model.Datum> data;
  String? points;
  String? session;
  String? digit;
  String? pana1;
  String? mType;

  GetSPDPTPBidEvent({
    /*required this.marketData,
      required this.gameDetails,*/
    this.game,
    this.index,
    this.digit,
    required this.data,
    required this.mType,
    this.points,
    this.session,
    this.id,
    this.pana1,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        /*  marketData,
        gameDetails,*/
        game,
        index,
        mType,
        digit,
        points,
        session,
        id,
        pana1,
      ];
}

class GetPittiesEvent extends BidEvents {
  String type;

  String pana;

  GetPittiesEvent({required this.type, required this.pana});

  @override
  // TODO: implement props
  List<Object?> get props => [type, pana];
}

class GetSuggestionsPittiesEvent extends BidEvents {
  final String type;
  final String q;

  GetSuggestionsPittiesEvent({required this.type, required this.q});

  @override
  // TODO: implement props
  List<Object?> get props => [type];
}

class PlaceSangamEvent extends BidEvents {
  MarketModel marketData;
  GameType gameDetails;
  int index;
  String mType;
  String pana1;
  String digit, points, gameStatus;

  PlaceSangamEvent({
    required this.marketData,
    required this.gameDetails,
    required this.mType,
    required this.index,
    required this.pana1,
    required this.digit,
    required this.points,
    required this.gameStatus,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        marketData,
        gameDetails,
        mType,
        index,
        pana1,
      ];
}

class PlaceBudEventerForPitties extends BidEvents {
  String marketId;

  /*GameType gameDetails;*/
  String mType;
  String pana1;
  String digit;
  String points, gameStatus;

  PlaceBudEventerForPitties({
    required this.marketId,
    required this.digit,
    /* required this.gameDetails,*/
    required this.mType,
    required this.pana1,
    required this.points,
    required this.gameStatus,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        marketId,
        digit,
        /* gameDetails,*/
        mType,
        pana1,
      ];
}

class StarLinePlaceBidEvent extends BidEvents {
  final String id;

  /*Starline id*/
  final int index;
  final String mtype;
  final String digit;
  final String points;

  StarLinePlaceBidEvent(
      {required this.index, required this.id, required this.mtype, required this.digit, required this.points});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddBidEvent extends BidEvents {
  String price;
  String digit;
  String status;
  String pana;
  String? mType;

  AddBidEvent({
    required this.digit,
    required this.price,
    required this.status,
    required this.pana,
    this.mType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        digit,
        price,
        status,
        pana,
        mType,
      ];
}

class InitialBidEvent extends BidEvents {
  InitialBidEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteBid extends BidEvents {
  int index;

  DeleteBid({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}
