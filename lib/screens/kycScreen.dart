// ignore_for_file: file_names, deprecated_member_use, use_super_parameters, sized_box_for_whitespace, avoid_print

import 'dart:typed_data';
import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dataapp/constant/colors.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({Key? key}) : super(key: key);

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  Uint8List? idFront;
  Uint8List? idBack;
  Uint8List? selfie;
  late TokenService tokenService;
  int currentMax = 1;
  late VtuApi vtuApi;

  final picker = ImagePicker();

  Future<void> selectImage(String type) async {
    Uint8List? im = await pickImage(ImageSource.gallery);

    if (im != null) {
      setState(() {
        if (type == "idFront") idFront = im;
        if (type == "idBack") idBack = im;
        if (type == "selfie") selfie = im;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      appBar: AppBar(
        title: const Text("KYC Verification"),
        backgroundColor: primaryColor.value,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 TITLE
            const Text(
              "Complete Your KYC",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              "Upload a government-issued ID and a selfie to verify your account.",
              style: TextStyle(
                fontSize: 14,
                color: labelColor.value,
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 UPLOAD CARDS
            _buildUploadCard("ID Front", idFront, () => selectImage("idFront")),
            const SizedBox(height: 20),
            _buildUploadCard("ID Back", idBack, () => selectImage("idBack")),
            const SizedBox(height: 20),
            _buildUploadCard("Selfie", selfie, () => selectImage("selfie")),
            const SizedBox(height: 30),

            // 🔹 SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.value,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () async {
                  if (idFront == null || idBack == null || selfie == null) {
                    Get.snackbar(
                      "Error",
                      "Please upload all required documents",
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  try {
                    Get.snackbar("Info", "Submitting KYC...",
                        backgroundColor: Colors.blue);
                   final token = await tokenService.getToken();
                    var result =
                        await vtuApi.kyc(token!, idFront!, idBack!, selfie!);

                    Get.snackbar(
                      "Success",
                      "KYC submitted successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );

                    print("KYC Result: $result");
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      e.toString(),
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text(
                  "Submit KYC",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(String title, Uint8List? file, VoidCallback onTap) {
    bool isUploaded = file != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryBackgroundColor.value,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: isUploaded
                  ? Colors.green.withOpacity(0.1)
                  : primaryColor.value.withOpacity(0.1),
              child: Icon(
                isUploaded ? Icons.check_circle : Icons.upload_file,
                color: isUploaded ? Colors.green : primaryColor.value,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: headingColor.value),
              ),
            ),
            Text(
              isUploaded ? "Uploaded" : "Upload",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isUploaded ? Colors.green : primaryColor.value),
            )
          ],
        ),
      ),
    );
  }
}
