import 'package:equatable/equatable.dart';
import 'package:mobi_user/model/win_history_model.dart';

abstract class WinHistoryState extends Equatable {}

class WinHistoryInitial extends WinHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WinHistoryLoading extends WinHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WinHistoryFetchedState extends WinHistoryState {
  final WinHistoryModel model;
  WinHistoryFetchedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
