import 'package:dio/dio.dart';

class Repository {
  final Dio _dio;

  Repository()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    // 🧩 Add your encryption interceptor later like this:
    // _dio.interceptors.add(EncryptionInterceptor());

    _dio.interceptors.add(LogInterceptor(request: true, requestBody: true, responseBody: true, error: true));
  }

  String errorMessage(var result) {
    return result["error"]?.toString() ??
        result["message"]?.toString() ??
        result["errors"]?.toString() ??
        result["msg"]?.toString() ??
        "Something went wrong";
  }

  /// 🌐 GET Request
  Future<Response> getRequest(String url, {Map<String, String>? header}) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: header, validateStatus: (status) => status != null && status < 800),
      );
      return response;
    } on DioException catch (e) {
      failureMessage(url: url, data: '', statusCode: e.response?.statusCode.toString() ?? '500');
      rethrow;
    }
  }

  /// 🌐 POST Request (JSON)
  Future<Response> postRequest(String url, dynamic data, {Map<String, String>? header}) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: header, validateStatus: (status) => status != null && status < 800),
      );
      return response;
    } on DioException catch (e) {
      failureMessage(url: url, data: data.toString(), statusCode: e.response?.statusCode.toString() ?? '500');
      rethrow;
    }
  }

  /// 📸 Multipart (for file uploads like category image)
  Future<Response> postMultipart(
    String url,
    Map<String, dynamic> formData, {
    Map<String, String>? header,
    bool withFormData = true,
    FormData? formdata,
  }) async {
    try {
      final form = formdata ?? FormData.fromMap(formData);
      final response = await _dio.post(
        url,
        data: form,
        options: Options(
          headers: {...?header, 'Content-Type': 'multipart/form-data'},
          validateStatus: (status) => status != null && status < 800,
        ),
      );
      return response;
    } on DioException catch (e) {
      failureMessage(url: url, data: formData.toString(), statusCode: e.response?.statusCode.toString() ?? '500');
      rethrow;
    }
  }

  /// 🧩 PATCH request (for update API)
  Future<Response> patchMultipart(
    String url,
    Map<String, dynamic> formData, {
    Map<String, String>? header,
    bool withFormData = true,
    FormData? formdata,
  }) async {
     try {
    final response = await _dio.patch(
      url,
      data: withFormData
          ? (formdata ?? FormData.fromMap(formData)) // ✅ multipart only when image
          : formData, // ✅ normal JSON when no image
      options: Options(
        headers: {
          ...?header,
          if (withFormData) 'Content-Type': 'multipart/form-data',
        },
        validateStatus: (status) => status != null && status < 800,
      ),
    );
    return response;
  } on DioException catch (e) {
      failureMessage(url: url, data: formData.toString(), statusCode: e.response?.statusCode.toString() ?? '500');
      rethrow;
    }
  }

  /// ❌ DELETE Request
  Future<Response> deleteRequest(String url, {Map<String, String>? header}) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: header, validateStatus: (status) => status != null && status < 800),
      );
      return response;
    } on DioException catch (e) {
      failureMessage(url: url, data: '', statusCode: e.response?.statusCode.toString() ?? '500');
      rethrow;
    }
  }

  /// 🪣 Error logger
  void failureMessage({required String url, required dynamic data, required String statusCode}) {
    print("❌ API Error:\nURL: $url\nBody: $data\nStatus Code: $statusCode");
  }

  /// 🧱 Getter to access Dio directly (for advanced use if needed)
  Dio get dio => _dio;
}
