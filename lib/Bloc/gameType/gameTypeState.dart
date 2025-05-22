import 'package:dartz/dartz.dart' as option;
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/gameType.dart';

abstract class GameTypeState extends Equatable {}

class InitialGameTypeState extends GameTypeState {
  InitialGameTypeState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GameTypeNowState extends GameTypeState {
  option.Option<Either<ApiFailure, dynamic>> apiFailureOrSuccessOption;
  List<GameType> gameList;
  GameTypeNowState({required this.apiFailureOrSuccessOption, required this.gameList});
  @override
  // TODO: implement props
  List<Object?> get props => [
        apiFailureOrSuccessOption,
      ];
}
