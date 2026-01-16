import 'dart:developer';

// import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Repository {
  http.Client? _client;

  http.Client getClient() {
    if (_client != null) return _client!;

    final pinKey = dotenv.env['KEY'];

    // ✅ Normal http client
    _client = http.Client();

    return _client!;
  }

  Future<http.Response> getRequest(String url, {Map<String, String>? header}) async {
    final resp = await getClient().get(Uri.parse(url), headers: header);
    return resp;
  }

  Future<http.Response> postRequest(String url, dynamic data, {Map<String, String>? header}) async {
    final resp = await getClient().post(Uri.parse(url), body: data, headers: header ?? {});
    return resp;
  }

  /// Log API failures
  void failureMessage({required String url, required String data, required String statusCode}) {
    log("❌ API Error:\n➡️ Url: $url\n➡️ Body: $data\n➡️ Status Code: $statusCode");
  }
}
