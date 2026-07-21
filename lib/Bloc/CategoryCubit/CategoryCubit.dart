import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Bloc/CategoryCubit/CategoryState.dart';
import 'package:planner_celebrity/model/CategoryModel.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final resp = await repository.getRequest(getAllCategoriesApi);
      final result = jsonDecode(jsonEncode(resp.data));
      log("GET Categories Response: $result");
      if (resp.statusCode == 200 && (result["status"] == true || result["success"] == true)) {
        emit(CategoryLoaded(CategoryModel.fromJson(result)));
      } else {
        emit(CategoryError(repository.errorMessage(result)));
      }
    } catch (e) {
      log("Catch error fetching categories: $e");
      emit(CategoryError("Failed to fetch categories: $e"));
    }
  }
}
