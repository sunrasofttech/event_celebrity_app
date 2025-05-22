import 'dart:developer';

import 'package:http/http.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

class Repository {
  Future<Response> getRequest(String url, {Map<String, String>? header}) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);
    final resp = await http.get(Uri.parse(url), headers: header);
    return resp;
  }

  Future<Response> postRequest(String url, var data, {Map<String, String>? header}) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);
    final resp = await http.post(Uri.parse(url), body: data, headers: header ?? {});
    return resp;
  }

  /*Note=> when server api status 500,404 then this method use*/
  failureMessage({required String url, required String data, required String statusCode}) {
    return log("Error in api Response=> \n Url=> ${url} body=> $data \n Status Code=> $statusCode");
  }
}
