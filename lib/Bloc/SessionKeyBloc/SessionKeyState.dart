class SessionKeyState {}

class SessionKeyInitialState extends SessionKeyState {}

class SessionKeyLoadingState extends SessionKeyState {}

class SessionKeyLoadedState extends SessionKeyState {
  final String key;
  SessionKeyLoadedState(this.key);
}

class SessionKeyErrorState extends SessionKeyState {
  final String error;
  SessionKeyErrorState(this.error);
}
