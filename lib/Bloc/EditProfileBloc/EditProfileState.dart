import 'package:equatable/equatable.dart';
import 'EditProfileModel.dart';
abstract class EditProfileState extends Equatable{}
class InitialState extends EditProfileState{
  @override
  List<Object?> get props => [];

}
class LoadingState extends EditProfileState{
  @override
  List<Object?> get props => [];
}
class LoadedState extends EditProfileState{
  final EditProfileModel model;
  LoadedState(this.model);
  @override
  List<Object?> get props => [model];

}
class ErrorState extends EditProfileState{
  final String error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
