import 'package:dartz/dartz.dart' as option;
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/error/api_failures.dart';

abstract class ChangePasswordState extends Equatable {}

class InitialChangePasswordState extends ChangePasswordState {
  InitialChangePasswordState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangePasswordNowState extends ChangePasswordState {
  option.Option<Either<ApiFailure, dynamic>> apiFailureOrSuccessOption;

  ChangePasswordNowState({required this.apiFailureOrSuccessOption});
  @override
  // TODO: implement props
  List<Object?> get props => [apiFailureOrSuccessOption];
}
