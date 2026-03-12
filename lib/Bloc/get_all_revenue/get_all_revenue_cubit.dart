import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/get_all_revenue/get_all_revenue_model.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';
part 'get_all_revenue_state.dart';

class GetAllRevenueCubit extends Cubit<GetAllRevenueState> {
  GetAllRevenueCubit() : super(GetAllRevenueInitial());

  getAllRevenue({String? filter, DateTime? startDate, DateTime? endDate}) async {
    try {
      emit(GetAllRevenueLoadingState());

      final token = await pref.getString(sharedPrefAPITokenKey);

       String url = "${Constants.baseUrl}/api/celebrity/getCelebrityRevenue";

      if (filter != null) {
        url = "$url?filter=$filter";
      }

      if (startDate != null && endDate != null) {
        String start = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
        String end = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

        url = "$url?startDate=$start&endDate=$end";
      }

      final resp = await repository.getRequest(
        url,
        header: {"Authorization": "Bearer $token"},
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("getAllRevenue RESPONSE :- $result");

      if (resp.statusCode == 200) {
        if (result["status"] == true) {
          emit(GetAllRevenueLoadedState(GetAllRevenueModel.fromJson(result)));
        } else {
          emit(GetAllRevenueErrorState(repository.errorMessage(result)));
        }
      } else {
        emit(GetAllRevenueErrorState(repository.errorMessage(result)));
      }
    } catch (e, stk) {
      print("Catch Error in Organizer Details: $e\n$stk");
      emit(GetAllRevenueErrorState("Something went wrong"));
    }
  }
}
