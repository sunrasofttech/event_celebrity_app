import 'package:dartz/dartz.dart' as option;
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidListModel.dart';

abstract class BidState extends Equatable {}

class InitialBidState extends BidState {
  List bidList;

  InitialBidState({required this.bidList});
  @override
  // TODO: implement props
  List<Object?> get props => [bidList];
}

class NullState {
  List bidList;
  NullState({required this.bidList});
  @override
  // TODO: implement props
  List<Object?> get props => [bidList];
}

class BidNowState extends BidState {
  List<BidListModel> bidList;
  String total;
  List<String> suggestionList;
  option.Option<Either<ApiFailure, dynamic>> apiFailureOrSuccessOption;
  BidNowState(
      {required this.apiFailureOrSuccessOption,
      required this.bidList,
      required this.total,
      required this.suggestionList});
  @override
  // TODO: implement props
  List<Object?> get props => [apiFailureOrSuccessOption, bidList, total, suggestionList];
}

class BidNowPlacedState extends BidState {
  List<BidListModel> bidList;
  String total;
  List<String> suggestionList;
  option.Option<Either<ApiFailure, dynamic>> apiFailureOrSuccessOption;
  BidNowPlacedState(
      {required this.apiFailureOrSuccessOption,
      required this.bidList,
      required this.total,
      required this.suggestionList});
  @override
  // TODO: implement props
  List<Object?> get props => [apiFailureOrSuccessOption, bidList, total, suggestionList];
}

class PattiState extends BidState {
  List bidList;
  String total;
  List<String> suggestionList;
  String pitties, selectedPana;
  option.Option<Either<ApiFailure, dynamic>> apiFailureOrSuccessOption;

  PattiState(
      {required this.apiFailureOrSuccessOption,
      required this.bidList,
      required this.total,
      required this.suggestionList,
      required this.pitties,
      required this.selectedPana});
  @override
  // TODO: implement props
  List<Object?> get props => [apiFailureOrSuccessOption, bidList, total, suggestionList, pitties];
}
