part of 'set_availbilty_cubit.dart';

sealed class SetAvailbiltyState extends Equatable {
  const SetAvailbiltyState();

}

final class SetAvailbiltyInitialState extends SetAvailbiltyState {
  @override
  List<Object> get props => [];
}

final class SetAvailbiltyLoadedState extends SetAvailbiltyState {
  @override
  List<Object> get props => [];
}

final class SetAvailbiltyLoadingState extends SetAvailbiltyState {
  @override
  List<Object> get props => [];
}

final class SetAvailbiltyErrorState extends SetAvailbiltyState {
   final String error;
  SetAvailbiltyErrorState(this.error);
  @override
  List<Object> get props => [error];
}
