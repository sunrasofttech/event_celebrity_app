import 'dart:developer';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatSocketService {
  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(
      Constants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"Authorization": "Bearer $token"})
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log("🟢 Socket connected");
    });

    

    socket.onDisconnect((_) {
      log("🔴 Socket disconnected");
    });
  }

   void joinRoom(String id, String type) {
    socket.emit("join_room", {"id": id, "type": type});

    log("📌 Joined Room: ${type}_$id");
  }


  void listenToMessages(Function(dynamic data) onMessage) {
    socket.on("receive_message", (data) {
      log("📩 Socket Message: $data");
      onMessage(data);
    });
  }

  void dispose() {
    socket.dispose();
  }
}
