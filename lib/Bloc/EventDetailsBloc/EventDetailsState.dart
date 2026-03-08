import 'EventDetailsModel.dart';

abstract class EventDetailsState {}

class EventDetailsInitialState extends EventDetailsState {}

class EventDetailsLoadingState extends EventDetailsState {}

class EventDetailsLoadedState extends EventDetailsState {
  final EventDetailsModel model;
  EventDetailsLoadedState(this.model);
}

class EventDetailsErrorState extends EventDetailsState {
  final String error;
  EventDetailsErrorState(this.error);
}
