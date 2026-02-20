import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Repository/repository.dart';
import '../../Repository/EncryptionService.dart';
import '../../Utility/const.dart';
import 'SessionKeyState.dart';

class SessionKeyCubit extends Cubit<SessionKeyState> {
  SessionKeyCubit() : super(SessionKeyInitialState());

  Future<void> sessionKey({String? tok}) async {
    emit(SessionKeyLoadingState());
    try {
      final _pref = await SharedPreferences.getInstance();
      final token = tok ?? _pref.getString(sharedPrefAPITokenKey) ?? "";
      var headers = {'Content-Type': 'application/json', 'Authorization': "Bearer ${token}"};
      // final body = jsonEncode({"mobile": mobile});

      final response = await Repository().getRequest(getSessionApi, header: headers);

      log("sessionKey API Response: ${response.data} --- token:- $token");

      final result = jsonDecode(jsonEncode(response.data));
      if (response.statusCode == 200) {
          final key = result["data"]["secure_key"];
        if (key != null) {
          final storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
          await storage.write(key: dotenv.env['ENCRYPTION_KEY_REQUEST'] ?? "ENCRYPTION_KEY_REQUEST", value: key);
          log("📝 Key saved in secure storage: $key");

          // Force reinitialize EncryptionService with the new key
          await EncryptionService().init(initAgain: true, keyy: key);

          emit(SessionKeyLoadedState(key));
        } else {
          emit(SessionKeyErrorState("Invalid response from server."));
        }
      } else {
        emit(SessionKeyErrorState(result["error"] ?? "Unknown error occurred."));
        log("Error in API response: ${response.data}");
      }
    } catch (e, stk) {
      emit(SessionKeyErrorState("Exception: $e"));
      log("Exception occurred while checking user: $e, $stk");
    }
  }
}
