import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/userProfileBloc/userProfileRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/userProfileModel.dart';

part 'user_profile_bloc_event.dart';
part 'user_profile_bloc_state.dart';

class UserProfileBlocBloc extends Bloc<UserProfileBlocEvent, UserProfileBlocState> {
  UserProfileBlocBloc() : super(UserProfileBlocInitial()) {
    on<GetUserProfileEvent>((event, emit) async {
      // TODO: implement event handler
      SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.getString("key") != null) {
        log("Call the Api Profile");
        var data = await UserProfileRepository().getUserProfile();
        log("Call the Api Profile ---->>> $data");
        /* var number = await UserProfileRepository().getNUmber();*/

        var isVersionChanged = await UserProfileRepository().getVersion();
        emit(UserProfileBlocInitial());
        data.fold(
          // TODO: Need to show error here change it later on..
          (left) => emit(UserProfileBlocInitial()),
          (right) {
            log("Call the Api Profile right ---->>> ${data.right.data?.lowBalanceAmountText}");
            emit(
              UserProfileFetchedState(
                user: data.right,
                //number: number.toString(),
                isVersionChanged: isVersionChanged,
              ),
            );
          },
        );
      }
    });
  }
}
