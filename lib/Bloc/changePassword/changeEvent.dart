import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {}

class ChangePasswordUserEvent extends ChangePasswordEvent {
  String newPassword, oldPassword;

  ChangePasswordUserEvent(
      {required this.newPassword, required this.oldPassword});
  @override
  // TODO: implement props
  List<Object?> get props => [newPassword, oldPassword];
}

class InitialChangePassword extends ChangePasswordEvent {
  InitialChangePassword();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
