import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'delete_gallery_image_state.dart';

class DeleteGalleryImageCubit extends Cubit<DeleteGalleryImageState> {
  DeleteGalleryImageCubit() : super(DeleteGalleryImageInitial());


  deleteGalleryImage(String id) async {
    try {
      emit(DeleteGalleryImageLoadingState());
      final resp = await repository.deleteRequest(
        "${Constants.baseUrl}/api/celebrity/deleteGalleryImage/$id",

        header: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("--- $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(
            DeleteGalleryImageLoadedState(),
          );
        } else {
          emit(DeleteGalleryImageErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(DeleteGalleryImageErrorState(result["error"]));
        } else {
          emit(DeleteGalleryImageErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
    }
  }
}
