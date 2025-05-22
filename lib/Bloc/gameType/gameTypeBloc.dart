import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gameRepository.dart';
import 'gameTypeEvent.dart';
import 'gameTypeState.dart';

class GameTypeBloc extends Bloc<GameTypeEvents, GameTypeState> {
  GameTypeBloc() : super(InitialGameTypeState()) {
    on<InitialEvents>(
      (event, emit) {
        emit(InitialGameTypeState());
      },
    );
    on<GameTypeEvents>(
      (event, emit) async {
        var data = await GameRepository().getAllAvailableGame();

        data.fold(
          (left) {
            emit(
              GameTypeNowState(
                apiFailureOrSuccessOption: optionOf(data),
                gameList: [],
              ),
            );
          },
          (right) {
            emit(
              GameTypeNowState(
                apiFailureOrSuccessOption: optionOf(data),
                gameList: right,
              ),
            );
          },
        );
      },
    );
  }
}
