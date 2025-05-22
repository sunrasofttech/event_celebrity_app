import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListModel.dart';

abstract class SuggestionListState extends Equatable {}

class InitialState extends SuggestionListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingState extends SuggestionListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedState extends SuggestionListState {
  final SuggestionListModel model;
  LoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class ErrorState extends SuggestionListState {
  final String error;
  ErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
