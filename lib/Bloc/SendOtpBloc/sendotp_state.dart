import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/SendOtpBloc/sendotp_model.dart';

abstract class SendOtpState extends Equatable {}

final class SendOtpInitial extends SendOtpState {
  @override
  List<Object?> get props => [];
}

final class SendOtpLoadingState extends SendOtpState {
  @override
  List<Object?> get props => [];
}

final class SendOtpLoadedState extends SendOtpState {
  final SendOtpModel model;
  SendOtpLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class SendOtpErrorState extends SendOtpState {
  final String error;
  SendOtpErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
