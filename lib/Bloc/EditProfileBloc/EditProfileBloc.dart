import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mobi_user/Bloc/EditProfileBloc/EditProfileEvent.dart';
import 'package:mobi_user/Bloc/EditProfileBloc/EditProfileModel.dart';
import 'package:mobi_user/Bloc/EditProfileBloc/EditProfileState.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(InitialState()) {
    on<InitialEvent>((event, emit) => emit(InitialState()));
    on<LoadedEvent>((event, emit) async {
      try {
        emit(LoadingState());
        log("------> edit profile api called <--------");
        var request = http.MultipartRequest(
          "PATCH",
          Uri.parse("${editProfileApi}/${pref.getString("key").toString()}"),
        );
        // request.fields["userid"] = pref.getString("key").toString();
        request.fields["name"] = event.username;
        // request.fields["email"] = event.email;
        // request.fields["mobile"] = event.phone;
        if (event.imageFile != null && event.imageFile!.path.isNotEmpty) {
          String fileName = event.imageFile!.path.split('/').last;
          request.files.add(
            await http.MultipartFile.fromPath(
              'image_path',
              event.imageFile!.path,
              filename: fileName,
              contentType: MediaType('image_path', 'png'),
            ),
          );
        }

        request.headers.addAll({
          "Content-type": "multipart/form-data",
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        });

        http.StreamedResponse response = await request.send();
        var body = await response.stream.bytesToString();
        log("Response=> " + body);
        final result = jsonDecode(body);
        log("Status Code=> " + response.statusCode.toString());
        if (response.statusCode == 200) {
          if (result["status"]) {
            emit(LoadedState(editProfileModelFromJson(body)));
          } else {
            emit(ErrorState(result["error"][0]));
          }
        } else {
          /* Error Message */
          emit(ErrorState(result["error"][0]));
        }
      } catch (e, stk) {
        emit(InitialState());
        log("Catch Error in update user api $e, $stk");
      }
    });
  }
}
