// ignore_for_file: file_names, sort_child_properties_last, deprecated_member_use


import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleChat extends StatefulWidget {
  const SingleChat({super.key});

  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final AppController userController = Get.put(AppController());
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messagesList = [];

  @override
  void initState() {
    super.initState();

    messagesList.add({
      "text":
          "Welcome John, welcome to DataEase Customer Chat Service. How may we help you?",
      "isMe": false,
    });

    // Example user messages (optional)
    messagesList.add({
      "text": "I want to make a complaint.",
      "isMe": true,
    });

    messagesList.add({
      "text": "That's great! what service are you having issues with?",
      "isMe": false,
    });
  }

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messagesList.add({"text": message, "isMe": true});
      });
      messageController.clear();
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
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage("https://res.cloudinary.com/damufjozr/image/upload/v1725521798/ck4g8mgwfmkcvajr58ki.png"),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DataEase",
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
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ListView.builder(
                  itemCount: messagesList.length,
                  itemBuilder: (BuildContext context, int index) {
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
                              minWidth: Get.width * 0.1,
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
                                    color:
                                        isMe ? lightColor : placeholderColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "sfpro",
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
              padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 10),
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
                        child: Icon(
                          Icons.attach_file_outlined,
                          color: primaryColor.value,
                        ),
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