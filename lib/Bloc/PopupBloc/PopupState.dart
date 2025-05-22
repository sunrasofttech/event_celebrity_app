import 'package:equatable/equatable.dart';

abstract class PopupState extends Equatable {}

class PopUpInitialState extends PopupState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PopUpLoadingState extends PopupState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PopUpLoadedState extends PopupState {
  final String popBanner;
  PopUpLoadedState(this.popBanner);
  @override
  // TODO: implement props
  List<Object?> get props => [popBanner];
}

class PopUpErrorState extends PopupState {
  final String error;
  PopUpErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
