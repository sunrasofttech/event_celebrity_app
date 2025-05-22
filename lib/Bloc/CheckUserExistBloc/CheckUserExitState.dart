class CheckUserState {}

class CheckUserInitialState extends CheckUserState {}

class CheckUserLoadingState extends CheckUserState {}

class CheckUserLoadedState extends CheckUserState {
  final String userType; // "new" or "old"
  CheckUserLoadedState(this.userType);
}

class CheckUserErrorState extends CheckUserState {
  final String error;
  CheckUserErrorState(this.error);
}
