// ignore_for_file: unnecessary_new, file_names, use_super_parameters, deprecated_member_use, strict_top_level_inference

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/login.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/services/utilservice.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final appController = Get.find<AppController>();

  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  late VtuApi vtuApi;
  late TokenService tokenService;

  var emailErr = ''.obs;
  var oldpassErr = ''.obs;
  var newpassErr = ''.obs;

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
  }

  Future<void> updatePassword(String password, String oldpassword) async {
    try {
      appController.loginLoader.value = true;

      String? token = await tokenService.getToken();

      if (token == null) {
        Get.snackbar("Error", "User session expired. Please login again");
        return;
      }

      var result = await vtuApi.updateUserPassword(token: token, password: password, oldpassword: oldpassword);

      print("response$result");

      if (result['status'] == 200) {
        Get.snackbar(
          "Success",
          "password updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Email OTP Error: $e");

      Get.snackbar(
        "Error",
        "Failed to update ",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      appController.loginLoader.value = false;
    }
  }

    verifyEmail() async {
    if (oldPasswordController.text.trim() == '') {
      oldpassErr.value = 'Please enter your Old Password';
    } else if (newPasswordController.text.trim() == '') {
      newpassErr.value = 'Please Enter new password.';
    } else {
      emailErr.value = '';
      await updatePassword(newPasswordController.text.trim(), oldPasswordController.text.trim());
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
                            )),
                      ),
                      Image.asset(
                        "images/logo.png",
                        height: 44,
                        width: 48,
                        color: primaryColor.value,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 92,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Update password",
                        style: TextStyle(
                          color: headingColor.value,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "sfpro",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 53,
                  ),
                  InputFieldsWithSeparateIcon(
                    textController: oldPasswordController,
                    headerText: "Old Password",
                    onChange: (val) {
                      oldpassErr.value = '';
                    },
                    svg: 'pass',
                    hasHeader: true,
                    hintText: 'Old Password',
                  ),
                  CommonWidgets.showErrorMessage(oldpassErr.value),
                  const SizedBox(
                    height: 31,
                  ),
                  InputFieldsWithSeparateIcon(
                    textController: newPasswordController,
                    headerText: "New Password",
                    onChange: (val) {
                      newpassErr.value = '';
                    },
                    svg: 'pass',
                    hasHeader: true,
                    hintText: 'New Password',
                  ),
                  CommonWidgets.showErrorMessage(newpassErr.value),
                  const SizedBox(
                    height: 31,
                  ),
                  BottomRectangularBtn(
                    onTapFunc: () {
                      verifyEmail();
                    },
                    btnTitle: "Update password",
                    color: primaryColor.value,
                    isLoading: appController.loginLoader.value,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
