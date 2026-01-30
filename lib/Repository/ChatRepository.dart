import 'dart:developer';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

class ChatRepository {
  ChatRepository();

  /// Send message
  Future<void> sendMessage({required String receiverId, required String receiverType, required String message}) async {
    final token = await pref.getString(sharedPrefAPITokenKey);
    final response = await repository.postRequest(
      "${Constants.baseUrl}/api/chat/celebrity/send",
     {"receiverId": receiverId, "receiverType": receiverType, "message": message},
      header: {"Authorization": "Bearer $token"},
    );

    log("This is send message response:-[${response.statusCode}] ${response.data}");
  }

  /// Get chat history
  Future<List<dynamic>> getChatHistory({required String adminId}) async {
    try {
      final token = await pref.getString(sharedPrefAPITokenKey);
      final response = await repository.getRequest(
        "${Constants.baseUrl}/api/chat/celebrity/history/$adminId",
        header: {"Authorization": "Bearer $token"},
      );
      log("This is get all message response:-[${response.statusCode}] ${response.data}");
      return response.data["data"] ?? [];
    } catch (e, s) {
      log("Catch Error on get chat history:- $e - $s");
      return [];
    }
  }
}
