// ignore_for_file: unnecessary_new, file_names, use_super_parameters, deprecated_member_use, strict_top_level_inference

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/home/dashboard.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/services/utilservice.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  final String userId;
  const OtpScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final appController = Get.find<AppController>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();

  var emailErr = ''.obs;
  late final VtuApi _vtuApi = VtuApi();
  late TokenService tokenService;
  var otpErr = ''.obs;

  late String userId;

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    userId = widget.userId;

    // ignore: avoid_print
    print("Received userId: $userId");
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
                  InputFieldsWithSeparateIcon(
                    textController: otpController,
                    headerText: "Otp",
                    onChange: (val) {
                      emailErr.value = '';
                    },
                    svg: 'pass',
                    hasHeader: true,
                    hintText: 'Otp ',
                  ),
                  CommonWidgets.showErrorMessage(otpErr.value),
                  const SizedBox(
                    height: 31,
                  ),
                  BottomRectangularBtn(
                    onTapFunc: () {
                      verifyEmail();
                    },
                    btnTitle: "Verify Email",
                    color: primaryColor.value,
                    isLoading: appController.registerLoader.value,
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
    } else if (otpController.text.trim() == '') {
      otpErr.value = 'please enter your Otp';
    } else {
      try {
        appController.registerLoader.value = true;
        final token = await tokenService.getToken();

         await _vtuApi.verifyOtp(
            token!, emailController.text.trim(), otpController.text.trim());
            
        Get.snackbar("Registration success","", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

        await TokenService().saveToken(token);
        Get.to(() => Dashboard());
      } catch (e) {
        Get.snackbar(
          "Registration Failed",
          e.toString().replaceAll("Exception: ", ""),
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        if (mounted) {
          appController.registerLoader.value = false;
        }
      }
    }
  }
}
