// ignore_for_file: empty_catches

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TokenService tokenService;
  late VtuApi vtuApi;

  AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    try {
      final token = await tokenService.getToken();
      final userId = await tokenService.getUserId();

      if (token == null || userId == null) return;

      await _loadUserProfile(token, userId);
    } catch (e) {}
  }

  Future<void> _loadUserProfile(String token, String userId) async {
    try {
      final profile = await vtuApi.getUserProfile(token, userId);

      appController.userName.value = profile["fullName"] ?? '';
      appController.email.value = profile["email"] ?? '';
      appController.img.value = profile["profilePic"] ?? '';
      appController.phone.value = profile["phoneNumber"] ?? '';
      appController.acctType.value = profile["userType"] ?? '';
      appController.verified.value = profile["isVerified"] ;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// PROFILE IMAGE SECTION
            Obx(
              () => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        appController.img.value.isNotEmpty
                            ? appController.img.value
                            : "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png",
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // upload image
                      },
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// WHITE CONTAINER SECTION
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Basic Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// FULL NAME
                      Obx(() => _infoTile(
                            "Full Name",
                            appController.userName.value,
                          )),

                      const SizedBox(height: 15),

                      /// EMAIL
                      Obx(() => _infoTile(
                            "Email",
                            appController.email.value,
                          )),

                      const SizedBox(height: 15),

                      /// PHONE NUMBER
                      Obx(() => _infoTile(
                            "Phone",
                            appController.phone.value,
                          )),

                      const SizedBox(height: 15),

                      /// ACCOUNT TYPE
                      Obx(() => _infoTile(
                            "Account Type",
                            appController.acctType.value,
                          )),

                      const SizedBox(height: 15),

                      /// VERIFIED STATUS
                      Obx(() => _verifiedTile(
                            "Verified",
                            appController.verified.value,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const Icon(Icons.edit, size: 18),
        ],
      ),
    );
  }

  Widget _verifiedTile(String title, bool isVerified) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$title: $isVerified ",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (isVerified)
            Icon(
              Icons.verified,
              color: Colors.green,
              size: 18,
            ),
        ],
      ),
    );
  }
}