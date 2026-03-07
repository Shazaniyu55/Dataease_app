// ignore_for_file: unnecessary_new, file_names, use_super_parameters, deprecated_member_use, strict_top_level_inference, avoid_print

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/otpScreen.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/services/utilservice.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmalScreen extends StatefulWidget {
  const VerifyEmalScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmalScreen> createState() => _VerifyEmalScreenState();
}

class _VerifyEmalScreenState extends State<VerifyEmalScreen> {
  final appController = Get.find<AppController>();
  late VtuApi vtuApi;
  late TokenService tokenService;

  TextEditingController emailController = TextEditingController();

  var emailErr = ''.obs;
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
  }

  Future<void> sendEmailOtp(String email) async {
    try {
      isLoading.value = true;

      String? token = await tokenService.getToken();
      final userId = await tokenService.getUserId();

      if (token == null) {
        Get.snackbar("Error", "User session expired. Please login again");
        return;
      }

      var result = await vtuApi.verifyemail(token, email);

      print("response$result");

      if (result['status'] == 200) {
        Get.snackbar(
          "Success",
          "OTP has been sent to your email",
          snackPosition: SnackPosition.BOTTOM,
        );

        if (userId != null) {
          Get.to(() => OtpScreen(userId: userId));
        }
      } else {
        Get.snackbar("Error", result['message']);
      }
    } catch (e) {
      print("Email OTP Error: $e");

      Get.snackbar(
        "Error",
        "Failed to send OTP",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  verifyEmail() async {
    if (emailController.text.trim() == '') {
      emailErr.value = 'Please enter your email';
    } else if (UtilService().isEmail(emailController.text) == false) {
      emailErr.value = 'Invalid Email.';
    } else {
      emailErr.value = '';
      await sendEmailOtp(emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: primaryBackgroundColor.value,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 29.0, vertical: 26),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          color: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: headingColor.value,
                          ),
                        ),
                      ),
                      Image.asset(
                        "images/logo.png",
                        height: 44,
                        width: 48,
                        color: primaryColor.value,
                      )
                    ],
                  ),
                  const SizedBox(height: 92),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verify Email",
                        style: TextStyle(
                          color: headingColor.value,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "sfpro",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 53),
                  InputFieldsWithSeparateIcon(
                    textController: emailController,
                    headerText: "Email",
                    onChange: (val) {
                      emailErr.value = '';
                    },
                    svg: 'email',
                    hasHeader: true,
                    hintText: 'Email Address',
                  ),
                  CommonWidgets.showErrorMessage(emailErr.value),
                  const SizedBox(height: 31),
                  isLoading.value
                      ? CircularProgressIndicator()
                      : BottomRectangularBtn(
                          onTapFunc: () {
                            verifyEmail();
                          },
                          btnTitle: "Verify Email",
                          color: primaryColor.value,
                        ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
