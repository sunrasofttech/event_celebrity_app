import 'package:planner_celebrity/Bloc/subscription_bloc/subscription_model.dart';

abstract class GetSubscriptionsState {}

class GetSubscriptionsInitial extends GetSubscriptionsState {}

class GetSubscriptionsLoading extends GetSubscriptionsState {}

class GetSubscriptionsLoaded extends GetSubscriptionsState {
  final SubscriptionModel subscriptions;
  GetSubscriptionsLoaded(this.subscriptions);
}

class GetSubscriptionsError extends GetSubscriptionsState {
  final String error;
  GetSubscriptionsError(this.error);
}

class GetSubscriptionsEndListState extends GetSubscriptionsState {
  final String error;
  GetSubscriptionsEndListState(this.error);
}
