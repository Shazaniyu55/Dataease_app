// ignore_for_file: unnecessary_new, file_names, use_super_parameters, deprecated_member_use, strict_top_level_inference

import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/login.dart';
import 'package:dataapp/services/utilservice.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final appController = Get.find<AppController>();

  TextEditingController emailController = new TextEditingController();
  var emailErr = ''.obs;
  @override
  void initState() {
    super.initState();
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
                        "Forgot password",
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
                  const SizedBox(
                    height: 31,
                  ),
                  BottomRectangularBtn(
                    onTapFunc: () {
                      verifyEmail();
                    },
                    btnTitle: "Recover your password",
                    color: primaryColor.value,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const LoginScreen());
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: primaryColor.value.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remembered password? ",
                            style: TextStyle(
                                color: headingColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                                color: headingColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                        ],
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  verifyEmail() async {
    if (emailController.text.trim() == '') {
      emailErr.value = 'Please enter your email';
    } else if (UtilService().isEmail(emailController.text) == false) {
      emailErr.value = 'Invalid Email.';
    } else {}
  }
}
