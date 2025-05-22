part of 'user_profile_bloc_bloc.dart';

abstract class UserProfileBlocState extends Equatable {}

class UserProfileBlocInitial extends UserProfileBlocState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserProfileFetchedState extends UserProfileBlocState {
  UserProfile user;
  bool isVersionChanged;
  UserProfileFetchedState({
    required this.user,
    required this.isVersionChanged,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
