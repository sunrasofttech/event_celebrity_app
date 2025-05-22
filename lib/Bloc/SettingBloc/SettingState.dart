import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingModel.dart';

abstract class SettingState extends Equatable {}

class SettingInitState extends SettingState {
  @override
  List<Object?> get props => [];
}

class SettingLoadingState extends SettingState {
  @override
  List<Object?> get props => [];
}

class SettingLoadedState extends SettingState {
  final SettingModel model;
  SettingLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class SettingErrorState extends SettingState {
  final String error;
  SettingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
