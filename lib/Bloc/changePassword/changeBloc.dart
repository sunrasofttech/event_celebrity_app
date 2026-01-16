import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Bloc/changePassword/authenticationRepository.dart';
import 'package:planner_celebrity/Bloc/changePassword/changeEvent.dart';
import 'package:planner_celebrity/Bloc/changePassword/changeState.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(InitialChangePasswordState()) {
    on<ChangePasswordUserEvent>((event, emit) async {
      var data = await AuthenticationRepository().changePassword(
        newPassword: event.newPassword,
        oldPassword: event.oldPassword,
      );
      // await checkloadMorePossible();

      data.fold((left) => emit(ChangePasswordNowState(apiFailureOrSuccessOption: optionOf(data))), (right) {
        emit(ChangePasswordNowState(apiFailureOrSuccessOption: optionOf(data)));
      });
    });

    on<InitialChangePassword>((event, emit) {
      emit(InitialChangePasswordState());
    });
  }
}
