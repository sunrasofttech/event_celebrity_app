part of 'update_notification_cubit.dart';

sealed class UpdateNotificationState extends Equatable {}

final class UpdateNotificationInitial extends UpdateNotificationState {
  @override
  List<Object?> get props => [];
}

final class UpdateNotificationLoadingState extends UpdateNotificationState {
  @override
  List<Object?> get props => [];
}

final class UpdateNotificationLoadedState extends UpdateNotificationState {
  @override
  List<Object?> get props => [];
}

final class UpdateNotificationErrorState extends UpdateNotificationState {
  final String error;
  UpdateNotificationErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
