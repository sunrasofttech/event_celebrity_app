import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import '../../Repository/ChatRepository.dart';
import '../../Repository/chat_socket_service.dart';
import '../../Utility/const.dart';
import '../../main.dart';

class ChatAssistantScreen extends StatefulWidget {
  const ChatAssistantScreen({super.key, this.receiverId});
  final String? receiverId;
  @override
  State<ChatAssistantScreen> createState() => _ChatAssistantScreenState();
}

class _ChatAssistantScreenState extends State<ChatAssistantScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> _messages = [];
  ValueNotifier<bool> textNotEmpty = ValueNotifier(false);
  final chatRepo = ChatRepository();
  final socketService = ChatSocketService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initChat();
    _scrollToBottom();
  }

  Future<void> _initChat() async {
    if (widget.receiverId == "") return;
    final token = pref.getString(sharedPrefAPITokenKey) ?? "";

    /// 1️⃣ Load history
    final history = await chatRepo.getChatHistory(
      adminId: widget.receiverId.toString(),
    );

    setState(() {
      _messages.addAll(
        history.map(
          (e) => ChatMessage(
            text: e["message"],
            isUser: e["senderType"] == "celebrity",
          ),
        ),
      );
    });

    /// 2️⃣ Connect socket
    socketService.connect(token);

    /// 3️⃣ Listen to incoming messages
    socketService.listenToMessages((data) {
      log(" >>>>>>>>> listenToMessages $data");
      setState(() {
        _messages.add(ChatMessage(text: data["message"], isUser: false));
      });
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();
    _controller.clear();

    /// Optimistic UI
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _scrollToBottom();
    await chatRepo.sendMessage(
      receiverId: widget.receiverId.toString(),
      receiverType: "admin",
      message: text,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    socketService.dispose();
    textNotEmpty.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(IconsaxPlusBold.arrow_left_3),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text("Chat Assistant"),
                ],
              ),
            ),

            /// MESSAGES
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment:
                        msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.5,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            msg.isUser
                                ? Colors.grey.shade300
                                : Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                },
              ),
            ),

            /// INPUT
            Padding(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder<bool>(
                valueListenable: textNotEmpty,
                builder: (context, _textNotEmpty, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (v) {
                            if (v.isNotEmpty) {
                              textNotEmpty.value = true;
                            } else {
                              textNotEmpty.value = false;
                            }
                            log(
                              "V- $v, text not empty:- ${textNotEmpty.value}",
                            );
                          },
                          decoration: const InputDecoration(
                            hintText: "Type message...",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          IconsaxPlusBold.send_2,
                          color: !_textNotEmpty ? greyColor : primaryColor,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
