import 'UserAppContentModel.dart';

abstract class GetUserAppContentState {}

class GetUserAppContentInitialState extends GetUserAppContentState {}

class GetUserAppContentLoadingState extends GetUserAppContentState {}

class GetUserAppContentLoadedState extends GetUserAppContentState {
  final UserAppContentModel model;
  GetUserAppContentLoadedState(this.model);
}

class GetUserAppContentErrorState extends GetUserAppContentState {
  final String error;
  GetUserAppContentErrorState(this.error);
}
