import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'add_gallery_images_state.dart';

class AddGalleryImagesCubit extends Cubit<AddGalleryImagesState> {
  AddGalleryImagesCubit() : super(AddGalleryImagesInitial());

  Future<void> addGalleryImages(List<File> images) async {
    try {
      emit(AddGalleryImagesLoadingState());

      final List<MultipartFile> files =
          images
              .map(
                (file) => MultipartFile.fromFileSync(
                  file.path,
                  filename: basename(file.path),
                ),
              )
              .toList();

      final Response resp = await repository.postMultipart(addGalleryImageApi, {
        "files": files,
      });

      final result = resp.data;

      if (resp.statusCode == 200 && result["status"] == true) {
        emit(AddGalleryImagesLoadedState());
      } else {
        emit(AddGalleryImagesErrorState(result["message"] ?? "Upload failed"));
      }
    } catch (e, stk) {
      log("Gallery Upload Error: $e");
      log("StackTrace: $stk");
      emit(AddGalleryImagesErrorState("Something went wrong"));
    }
  }
}
