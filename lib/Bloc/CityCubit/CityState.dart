import 'package:planner_celebrity/model/CityModel.dart';

abstract class CityState {
  const CityState();
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final CityModel model;
  const CityLoaded(this.model);
}

class CityError extends CityState {
  final String error;
  const CityError(this.error);
}
