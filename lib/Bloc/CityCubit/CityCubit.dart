import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Bloc/CityCubit/CityState.dart';
import 'package:planner_celebrity/model/CityModel.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());

  Future<void> fetchCities() async {
    emit(CityLoading());
    try {
      final resp = await repository.getRequest(getAllCitiesApi);
      final result = jsonDecode(jsonEncode(resp.data));
      log("GET Cities Response: $result");
      if (resp.statusCode == 200 && (result["status"] == true || result["success"] == true)) {
        emit(CityLoaded(CityModel.fromJson(result)));
      } else {
        // Fallback to /api/celebrity/getAllCities if admin endpoint fails
        final altResp = await repository.getRequest('${Constants.baseUrl}/api/celebrity/getAllCities');
        final altResult = jsonDecode(jsonEncode(altResp.data));
        if (altResp.statusCode == 200 && (altResult["status"] == true || altResult["success"] == true)) {
          emit(CityLoaded(CityModel.fromJson(altResult)));
        } else {
          emit(CityError(repository.errorMessage(result)));
        }
      }
    } catch (e) {
      log("Catch error fetching cities: $e");
      emit(CityError("Failed to fetch cities: $e"));
    }
  }
}
