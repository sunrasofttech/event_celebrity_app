// import 'dart:convert';
//
// import 'package:dio/dio.dart';
//
// import 'EncryptionService.dart';
//
// class EncryptionInterceptor extends Interceptor {
//   final EncryptionService _encryptionService = EncryptionService();
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (options.data != null) {
//       // Convert body to JSON and encrypt
//       final body = jsonEncode(options.data);
//       final encryptedBody = _encryptionService.encrypt(body);
//
//       // Send only encrypted data
//       options.data = {"data": encryptedBody};
//     }
//     super.onRequest(options, handler);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     try {
//       if (response.data is Map && response.data['data'] != null) {
//         // Decrypt response data
//         final decrypted = _encryptionService.decrypt(response.data['data']);
//         response.data = jsonDecode(decrypted); // Replace with decrypted JSON
//       }
//     } catch (e) {
//       print("Decryption failed: $e");
//     }
//     super.onResponse(response, handler);
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../Utility/const.dart';
import 'EncryptionService.dart';

class EncryptionInterceptor extends Interceptor {
  final EncryptionService _encryptionService = EncryptionService();
  EncryptionInterceptor._internal();
  static final EncryptionInterceptor _instance = EncryptionInterceptor._internal();
  factory EncryptionInterceptor() => _instance;
  bool _initialized = false;
  final List<String> excludedApis = [loginApi, settingApi];

  bool _isExcluded(String url) {
    return excludedApis.any((api) => url.contains(api));
  }

  Future<void> _init() async {
    // if (!_initialized) {
    _initialized = await _encryptionService.init();
    // }

    log("Encrption----> $_initialized");
  }

  void clearInitialization() {
    _initialized = false;
    log("======= $_initialized");
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await _init();
    log("➡️ Request URL: ${options.uri}");

    if (_isExcluded(options.uri.toString()) || !_initialized) {
      log("⏭️ Skipping encryption for ${options.uri}");
      return super.onRequest(options, handler);
    } else if (options.data != null) {
      try {
        // Convert body to JSON and encrypt
        final body = jsonEncode(options.data);
        final encryptedPayload = _encryptionService.encryptWithIV(body);
        // Send encrypted data and IV
        options.data = encryptedPayload;
      } catch (e, s) {
        print("Encryption failed: $e, $s");
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    await _init();

    log("⬅️ Response from: ${response.requestOptions.uri}");

    try {
      if (_isExcluded(response.requestOptions.uri.toString()) || !_initialized) {
        log("⏭️ Skipping decryption for ${response.requestOptions.uri}");
        return super.onResponse(response, handler);
      } else if (response.data is Map && response.data['data'] != null && response.data['iv'] != null) {
        final encryptedData = response.data['data'];
        final iv = response.data['iv'];
        log("Response before decryption:- ${response.data}");
        // Decrypt response
        final decrypted = _encryptionService.decryptWithIV(encryptedData, iv);
        response.data = jsonDecode(decrypted);
        if (kDebugMode) {
          log("Response after decryption:- \nLink:-${response.requestOptions.uri.toString()} \nResponse:$decrypted");
        }
      }
    } catch (e, s) {
      print("Decryption failed: $e, $s");
    }

    super.onResponse(response, handler);
  }
}
