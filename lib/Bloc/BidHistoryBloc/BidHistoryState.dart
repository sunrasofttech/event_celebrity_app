import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/BidHistoryBloc/BidHistoryModel.dart';

abstract class BidHistoryState extends Equatable {}

class BidHistoryInitState extends BidHistoryState {
  @override
  List<Object?> get props => [];
}

class BidHistoryLoadingState extends BidHistoryState {
  @override
  List<Object?> get props => [];
}

class BidHistoryLoadedState extends BidHistoryState {
  final BidHistoryModel model;
  BidHistoryLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class BidHistoryErrorState extends BidHistoryState {
  final String error;
  BidHistoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
