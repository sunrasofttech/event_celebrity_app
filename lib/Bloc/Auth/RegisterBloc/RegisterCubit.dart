import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Bloc/Auth/RegisterBloc/RegisterState.dart';
import 'package:planner_celebrity/model/userProfileModel.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  /// 📲 Send OTP to celebrity mobile
  Future<void> sendOtp(String mobile) async {
    emit(SendOtpLoading());
    try {
      log("Sending OTP to $mobile via $sendOtpCelebrityApi");
      final resp = await repository.postRequest(
        sendOtpCelebrityApi,
        {"mobile": mobile},
        header: {'Content-Type': 'application/json'},
      );
      final result = jsonDecode(jsonEncode(resp.data));
      log("SEND OTP RESPONSE: $result");

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        if (result["status"] == true || result["success"] == true) {
          emit(
            SendOtpSuccess(
              message: result["message"]?.toString() ?? "OTP sent successfully",
              mobile: mobile,
            ),
          );
        } else {
          emit(SendOtpError(repository.errorMessage(result)));
        }
      } else {
        emit(SendOtpError(repository.errorMessage(result)));
      }
    } catch (e) {
      log("Catch Error on Send OTP: $e");
      emit(SendOtpError("Failed to send OTP: $e"));
    }
  }

  /// 🔐 Verify OTP & Complete Celebrity Registration
  Future<void> verifyOtpRegister({
    required String otp,
    required String mobile,
    required String email,
    required String password,
    required String fullName,
    required String publicHandle,
    required String shortBio,
    required String location,
    required String cityId,
    required List<String> categoryIds,
    required List<RateCard> rateCard,
    required String instagramHandle,
    required String twitterHandle,
    String? profilePicturePath,
    String? aadharFrontImagePath,
    String? aadharBackImagePath,
    String latitude = "19.0760",
    String longitude = "72.8777",
  }) async {
    emit(VerifyRegisterLoading());
    try {
      final deviceToken =
          pref.getString(sharedPrefFCMTokenKey) ?? "device_token_here";
      final platform = Platform.isIOS ? "ios" : "android";

      final socialMediaMap = {
        "instagram": instagramHandle,
        "twitter": twitterHandle,
      };

      final rateCardJson = jsonEncode(rateCard.map((e) => e.toJson()).toList());
      final socialMediaLinksJson = jsonEncode(socialMediaMap);
      final categoryIdsJson = jsonEncode(categoryIds);

      final Map<String, dynamic> formMap = {
        'otp': otp,
        'mobile': mobile,
        'email': email,
        'password': password,
        'fullName': fullName,
        'publicHandle': publicHandle,
        'shortBio': shortBio,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'deviceToken': deviceToken,
        'platform': platform,
        'categoryIds': categoryIdsJson,
        'socialMediaLinks': socialMediaLinksJson,
        'rateCard': rateCardJson,
      };

      final data = FormData.fromMap(formMap);

      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        final mimeType =
            lookupMimeType(profilePicturePath)?.split('/') ?? ['image', 'png'];
        final file = await MultipartFile.fromFile(
          profilePicturePath,
          filename: profilePicturePath.split('/').last,
          contentType: MediaType(mimeType[0], mimeType[1]),
        );
        data.files.add(MapEntry('profilePicture', file));
      }

      if (aadharFrontImagePath != null && aadharFrontImagePath.isNotEmpty) {
        final mimeType =
            lookupMimeType(aadharFrontImagePath)?.split('/') ?? ['image', 'png'];
        final file = await MultipartFile.fromFile(
          aadharFrontImagePath,
          filename: aadharFrontImagePath.split('/').last,
          contentType: MediaType(mimeType[0], mimeType[1]),
        );
        data.files.add(MapEntry('aadharFrontImage', file));
      }

      if (aadharBackImagePath != null && aadharBackImagePath.isNotEmpty) {
        final mimeType =
            lookupMimeType(aadharBackImagePath)?.split('/') ?? ['image', 'png'];
        final file = await MultipartFile.fromFile(
          aadharBackImagePath,
          filename: aadharBackImagePath.split('/').last,
          contentType: MediaType(mimeType[0], mimeType[1]),
        );
        data.files.add(MapEntry('aadharBackImage', file));
      }

      final curlCmd = StringBuffer();
      curlCmd.writeln("curl --location '$verifyOtpRegisterApi' \\");
      formMap.forEach((key, value) {
        final escapedVal = value.toString().replaceAll("'", "'\\''");
        curlCmd.writeln("  --form '$key=\"$escapedVal\"' \\");
      });
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        curlCmd.writeln("  --form 'profilePicture=@\"$profilePicturePath\"' \\");
      }
      if (aadharFrontImagePath != null && aadharFrontImagePath.isNotEmpty) {
        curlCmd.writeln("  --form 'aadharFrontImage=@\"$aadharFrontImagePath\"' \\");
      }
      if (aadharBackImagePath != null && aadharBackImagePath.isNotEmpty) {
        curlCmd.writeln("  --form 'aadharBackImage=@\"$aadharBackImagePath\"'");
      }
      log("VERIFY OTP REGISTER CURL:\n${curlCmd.toString()}");

      log("VERIFY OTP REGISTER FormData payload fields: ${data.fields}");

      final resp = await repository.postMultipart(
        verifyOtpRegisterApi,
        {},
        withFormData: true,
        formdata: data,
      );

      dynamic result = resp.data;
      if (result is String) {
        try {
          result = jsonDecode(result);
        } catch (_) {}
      } else {
        result = jsonDecode(jsonEncode(resp.data));
      }
      log("VERIFY OTP REGISTER RESPONSE: $result");

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        if (result is Map && (result["status"] == true || result["success"] == true)) {
          emit(
            VerifyRegisterSuccess(
              responseData: Map<String, dynamic>.from(result),
              message:
                  result["message"]?.toString() ??
                  "Registration completed successfully",
            ),
          );
        } else {
          emit(VerifyRegisterError(repository.errorMessage(result)));
        }
      } else {
        emit(VerifyRegisterError(repository.errorMessage(result)));
      }
    } catch (e) {
      log("Catch Error on Verify OTP Register: $e");
      emit(VerifyRegisterError("Failed to verify & register: $e"));
    }
  }
}
