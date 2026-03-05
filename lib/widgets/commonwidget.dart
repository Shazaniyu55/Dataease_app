// ignore_for_file: file_names, deprecated_member_use, avoid_print, strict_top_level_inference

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/model/walletBalace.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/services/utilservice.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:dataapp/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CommonWidgets {
  final appController = Get.find<AppController>();

  TextEditingController amountController = TextEditingController();
  var amountErrBox = ''.obs;
  var bankNameErrBox = ''.obs;
  var accountNumErrBox = ''.obs;
  var amountFiatErrBox = ''.obs;
  var accountNameErrBox = ''.obs;

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumController = TextEditingController();
  TextEditingController amountFiatController = TextEditingController();
final VtuApi vtuApi = VtuApi();
final UtilService _utilService = UtilService();


Future<void> handlePayment(String token, String amount) async {
  try {
    final result = await vtuApi.fundWallet(token, amount);

    final authorizationUrl = result["authorization_url"];
    final reference = result["reference"];
      AppController appController = Get.find<AppController>();


    // Save reference for verification later
    print("Reference: $reference");
    appController.paymentReference.value = reference;

      
    _utilService.launchURL(authorizationUrl);

      Get.defaultDialog(
      title: "Verify Payment",
      middleText: "Click below after completing payment",
      actions: [
        ElevatedButton(
          onPressed: () async {
            try {
              final verification = await vtuApi.verifyPayment(token, reference);
              if (verification["data"]["status"] == "success") {
                Get.back(); // close dialog
                Get.snackbar("Success", "Wallet funded successfully", backgroundColor: Colors.green, colorText: Colors.white);
              } else {
                Get.snackbar("Failed", verification["data"]["message"] ?? "Payment not verified");
              }
            } catch (e) {
              Get.snackbar("Error", e.toString());
            }
          },
          child: const Text("I Have Paid"),
        )
      ],
    );

  } catch (e) {
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
  }
}

  static Widget showErrorMessage(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4.0, bottom: 2),
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontFamily: 'sfpro',
        ),
      ),
    );
  }

  static Widget confirmationDialogUI(context, a1, a2,
      {String? title, String? description, Function? onConfirm}) {
    return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: cardColor.value),
      child: Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            elevation: 10,
            backgroundColor: cardColor.value,
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0)),
            actionsPadding:
                const EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 0),
            title: Center(
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: inputFieldTextColor.value,
                  fontFamily: 'sfpro',
                ),
              ),
            ),
            content: Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: inputFieldTextColor.value,
                fontFamily: 'sfpro',
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: primaryColor.value),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton(
                  child: Text(
                    description.contains('delete') ? 'Cancel' : 'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      color: inputFieldTextColor.value,
                      fontFamily: 'sfpro',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 4),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryColor.value,
                  border: Border.all(width: 1, color: primaryColor.value),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton(
                  child: Text(
                    description.contains('delete') ? 'Delete' : "Enable",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'sfpro',
                    ),
                  ),
                  onPressed: () async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget loadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.white.withOpacity(0.75),
      child: Container(
        alignment: Alignment.centerLeft,
        width: 66,
        child: Text(
          'Loading...',
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'sfpro',
              color: inputFieldTextColor.value),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget appBar({
    bool? hasBack,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          if (hasBack != false)
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                color: Colors.transparent,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: lightColor,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            width: Get.width - (hasBack != false ? 105 : 65),
            child: Text(
              '$title',
              style: TextStyle(
                  fontFamily: 'sfpro',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 26.0,
                  letterSpacing: 0.36,
                  color: lightColor),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Future selectWithdrawBottomSheet(BuildContext context,
      {Balance? selectedToken}) {
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: primaryBackgroundColor.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      Obx(
        () => Container(
          width: Get.width,
          //color: primaryBackgroundColor.value,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fund Wallet",
                    style: TextStyle(
                        fontFamily: 'sfpro',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 26.0,
                        letterSpacing: 0.44,
                        color: headingColor.value),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.clear,
                        color: headingColor.value,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please select a method to continue",
                style: TextStyle(
                    fontFamily: 'sfpro',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    letterSpacing: 0.44,
                    color: placeholderColor),
              ),
              const SizedBox(
                height: 36,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                    onTap: () {
                      Get.back(); // close method selector
                      showPaystackAmountPopup(context);
                    },
                    child: Container(
                      height: 100,
                      width: 112,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: primaryColor.value.withOpacity(0.06),
                          //border: Border.all(color: primaryColor.value,width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/paystack.png"),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Paystack",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inputFieldTextColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      //CommonWidgets().buildBottomSheetWithDrawBank(context);
                      // Get.to(const WithdrawFiat());
                    },
                    child: Container(
                      height: 100,
                      width: 112,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: primaryColor.value.withOpacity(0.06),
                          //border: Border.all(color: primaryColor.value,width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/monify.png",
                            width: 100,
                            height: 60,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Monni",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inputFieldTextColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      //CommonWidgets().buildBottomSheetWithDrawBank(context);
                      // Get.to(const WithdrawFiat());
                    },
                    child: Container(
                      height: 100,
                      width: 112,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: primaryColor.value.withOpacity(0.06),
                          //border: Border.all(color: primaryColor.value,width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/bank.png"),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Bank",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inputFieldTextColor.value,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "sfpro",
                                height: 1.40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }




void showPaystackAmountPopup(BuildContext context) {
  final amountController = TextEditingController();
  final appController = Get.find<AppController>();
  var amountError = ''.obs;

  Get.dialog(
    AlertDialog(
      title: const Text("Fund Wallet"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputFieldsWithSeparateIcon(
            headerText: "Amount",
            hintText: "Amount",
            svg: 'wallet',
            onChange: (val) {
              if (val != null && val != '') {
                amountError.value = '';
              }
            },
            textController: amountController,
            hasHeader: true,
          ),
          const SizedBox(height: 15),
        ],
      ),
      actions: [
        BottomRectangularBtn(
          onTapFunc: () async{
            final amount = amountController.text.trim();

            if (amount.isEmpty) {
              Get.snackbar("Error", "Amount is required");
              return;
            }
            final token = await TokenService().getToken();
             if (token == null) {
                  Get.snackbar("Error", "User not authenticated");
                  return;
                }

            Get.back();
            await handlePayment(token, amount);
          },
          btnTitle: "Fund Wallet",
          color: primaryColor.value,
          loadingText: 'Funding account...',
          isLoading: appController.registerLoader.value,
        ),
      ],
    ),
  );
}

}

