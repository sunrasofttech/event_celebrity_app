import 'package:equatable/equatable.dart';

abstract class GetPhoneNumberState extends Equatable {}

class GetPhoneNumberInitState extends GetPhoneNumberState {
  @override
  List<Object?> get props => [];
}

class GetPhoneNumberLoadingState extends GetPhoneNumberState {
  @override
  List<Object?> get props => [];
}

class GetPhoneNumberLoadedState extends GetPhoneNumberState {
  final String model;
  GetPhoneNumberLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetPhoneNumberErrorState extends GetPhoneNumberState {
  final String error;
  GetPhoneNumberErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
