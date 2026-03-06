// ignore_for_file: deprecated_member_use, use_super_parameters, use_build_context_synchronously, strict_top_level_inference, strict_top_level_inference, duplicate_ignore
import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/home/dashboard.dart';
import 'package:dataapp/screens/signup.dart';
import 'package:dataapp/screens/forgotpass.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/services/utilservice.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final appController = Get.find<AppController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  var passErr = ''.obs;
  bool _isLoading = false;
  var emailErr = ''.obs;
  // ignore: unused_field
  late final VtuApi _vtuApi = VtuApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: primaryBackgroundColor.value,
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: primaryBackgroundColor.value,

              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: appController.isDark.value == true
                  ? Brightness.dark
                  : Brightness.light,
            ),
            elevation: 0,
          ),
        ),
        backgroundColor: primaryBackgroundColor.value,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29.0, vertical: 26),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/logo.png",
                      color: primaryColor.value,
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
                const SizedBox(
                  height: 53,
                ),
                InputFieldsWithSeparateIcon(
                  headerText: "Email",
                  hintText: "Email Address",
                  svg: 'email',
                  onChange: (val) {
                    if (val != null && val != '') {
                      emailErr.value = '';
                    }
                  },
                  textController: emailController,
                  hasHeader: true,
                ),
                CommonWidgets.showErrorMessage(emailErr.value),
                InputFieldPassword(
                  headerText: "Password",
                  svg: 'key',
                  hintText: '• • • • • • • •',
                  onChange: (val) {
                    if (val != null && val != '') {
                      passErr.value = '';
                    }
                  },
                  textController: passController,
                ),
                CommonWidgets.showErrorMessage(passErr.value),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(()=> ForgotPassword());
                      },
                      child: Text(
                        "forgot password?",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          fontFamily: "sfpro",
                          color: headingColor.value,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : verifyFields,
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 105, 107, 255),
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Get.to(const SignupScreen());
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: headingColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                          Text(
                            " Sign Up",
                            style: TextStyle(
                                color: primaryColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                        ],
                      ),
                    ),
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
    );
  }

  verifyFields() async {
    if (emailController.text.trim() == '') {
      emailErr.value = 'Please enter your email.';
    } else if (UtilService().isEmail(emailController.text) == false) {
      emailErr.value = 'Invalid Email.';
    } else if (passController.text.trim() == '') {
      passErr.value = 'Please enter your password.';
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        appController.loginLoader.value = true;
        final response = await _vtuApi.login(
            emailController.text.trim(), passController.text.trim());

        final token = response["token"];
        final userId = response["user"]["_id"];

        await TokenService().saveToken(token);
        await TokenService().saveUserId(userId);
        Get.to(() =>  Dashboard());
      } catch (e) {
        Get.snackbar(
          "Login Failed",
          e.toString().replaceAll("Exception: ", ""),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent, colorText: Colors.white
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
            appController.loginLoader.value = false;

        }
      }
    }
  }
}
