// ignore_for_file: file_names, sort_child_properties_last, deprecated_member_use

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatVendor extends StatefulWidget {
  final String profilePic;
  final String fullName;
  const ChatVendor({super.key, required this.profilePic, required this.fullName});

  @override
  State<ChatVendor> createState() => _ChatVendorState();
}

class _ChatVendorState extends State<ChatVendor> {
  final TextEditingController messageController = TextEditingController();
  late TokenService tokenService;
  late VtuApi vtuApi;

  AppController appController = Get.find<AppController>();

  late String token;
  late String userId;

//Replace with your real admin ID from database
  String adminId = "69a75697c739ee5c47525ef4";

  List<Map<String, dynamic>> messagesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
    _initializeChat();
  }

 void sendMessage() async {
  String message = messageController.text.trim();
  if (message.isEmpty) return;

  messageController.clear();

  try {
    await vtuApi.sendVendorMessage(
      token: token,
      senderId: userId,
      receiverId: adminId,
      message: message,
    );

    setState(() {
      messagesList.add({
        "text": message,
        "isMe": true,
      });
    });

  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString().replaceAll("Exception: ", ""),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  String generateConversationId(String userId, String adminId) {
    if (userId.compareTo(adminId) < 0) {
      return userId + adminId;
    } else {
      return adminId + userId;
    }
  }

  Future<void> _initializeChat() async {
    try {
      token = await tokenService.getToken() ?? '';
      userId = await tokenService.getUserId() ?? '';

      if (token.isEmpty || userId.isEmpty) return;

      await loadMessages();
    } catch (e) {
      //print(e);
    }
  }

  Future<void> loadMessages() async {
  try {
    String conversationId =
        generateConversationId(userId, adminId);

    final response = await vtuApi.getVendorConversation(
      token: token,
      conversationId: conversationId,
    );

    List chats = response["data"];

    setState(() {
      messagesList = chats.map<Map<String, dynamic>>((chat) {
        return {
          "text": chat["message"],
          "isMe": chat["senderId"] == userId,
        };
      }).toList();

      isLoading = false;
    });
  } catch (e) {
    //print("Error loading chat: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 10),
                   CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.profilePic),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullName,
                        style: TextStyle(
                          color: inputFieldTextColor.value,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "sfpro",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12.withOpacity(0.08),
            ),

            // Chat Messages
            Expanded(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ListView.builder(
            itemCount: messagesList.length,
            itemBuilder: (context, index) {
              bool isMe = messagesList[index]['isMe'] == true;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.75,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: isMe
                                ? const Radius.circular(15)
                                : const Radius.circular(0),
                            bottomRight: isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(15),
                          ),
                          color: isMe
                              ? primaryColor.value
                              : chatBoxBg.value,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Text(
                            messagesList[index]['text'],
                            style: TextStyle(
                              color: isMe
                                  ? lightColor
                                  : placeholderColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
),

            // Message Input
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Input
                  Expanded(
                    child: InputFields(
                      textController: messageController,
                      headerText: '',
                      hintText: 'Write a message',
                      hasHeader: true,
                      
                      onChange: (value) {},
                      suffixIcon: RotationTransition(
                        turns: const AlwaysStoppedAnimation(25 / 360),
                        
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send Button
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor.value,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
