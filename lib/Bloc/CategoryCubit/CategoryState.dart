import 'package:planner_celebrity/model/CategoryModel.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final CategoryModel model;
  const CategoryLoaded(this.model);
}

class CategoryError extends CategoryState {
  final String error;
  const CategoryError(this.error);
}
