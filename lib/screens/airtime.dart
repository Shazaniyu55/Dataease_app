// ignore_for_file: unused_field, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, avoid_print, non_constant_identifier_names

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TokenService tokenService;
  AppController appController = Get.find<AppController>();

  TextEditingController _phone = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController requestId = TextEditingController();
  TextEditingController serviceId = TextEditingController();

  double walletBalance = 0.0;
  late VtuApi vtuApi;

  String? _selectedMerchant;

  final List<Map<String, String>> _dropdownItemsAirtime = [
    {"val": "9mobile", "name": "9Mobile", "image": "images/9mobile.png"},
    {"val": "airtel", "name": "Airtel", "image": "images/airtel.png"},
    {"val": "glo", "name": "Glo", "image": "images/glo.png"},
    {"val": "mtn", "name": "MTN", "image": "images/download.png"},
  ];

  @override
  void initState() {
    super.initState();
    tokenService = TokenService();
    vtuApi = VtuApi();
    _initializeDashboard();
  }

  String generateRequestId(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return "${userId}_$timestamp";
  }

  Future<void> _initializeDashboard() async {
    try {
      final token = await tokenService.getToken();
      final userId = await tokenService.getUserId();

      if (token == null || userId == null) {
        print("Missing token or userId");
        return;
      }

      await _loadBalance(token);
    } catch (e) {
      print("Dashboard init error: $e");
    }
  }

  void _onRefresh() async {
    await _initializeDashboard();

    // Simulate a delay for refreshing
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // Optional: for load more functionality
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  Future<void> _loadBalance(String token) async {
    try {
      final result = await vtuApi.checkBalance(token);

      setState(() {
        walletBalance = double.tryParse(
              result["data"]["balance"].toString(),
            ) ??
            0.0;
      });
    } catch (e) {
      print("Error fetching balance: $e");
    }
  }

  void verifyFields() async {
    String phone = _phone.text.trim();
    String amountText = _amount.text.trim();
    final token = await tokenService.getToken();
    final userId = await tokenService.getUserId();
    String request_id = generateRequestId(userId!);
     // Show loader BEFORE API call
  

    if (phone.isEmpty) {
      Get.snackbar(
        "Phone number is required",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (phone.length != 10) {
      Get.snackbar(
        "Invalid phone number",
        "Enter 10 digits (without +234)",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (amountText.isEmpty) {
      Get.snackbar(
        "Amount is required",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        "Invalid amount",
        "Enter a valid amount",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedMerchant == null) {
      Get.snackbar(
        "Select a network",
        "Please choose a merchant",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (amount > walletBalance) {
      Get.snackbar(
        "Insufficient balance",
        "Your wallet balance is too low",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    appController.loginLoader.value = true;

     try {
    final response = await vtuApi.purchaseAirtime(
        token!, "234$phone", amount, request_id, _selectedMerchant!);

    if (response['status'] == "success") {
      Get.snackbar("Success", "Airtime purchase successful",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Purchase Failed", response['message'],
          snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar("Error", e.toString(),
        snackPosition: SnackPosition.BOTTOM);
  } finally {
    // Always hide loader at the end
    appController.loginLoader.value = false;
  }

    

    // If all validations pass
    //await _purchaseAirtime(phone, amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: appBgGradient,
      ),
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              "Airtime",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: primaryColor.value,
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: primaryColor.value,
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          body: Obx(
            () => SingleChildScrollView(
              child: Container(
                height: Get.height,
                child: Column(
                  children: [
                    Container(
                      height: 210,
                      padding:
                          const EdgeInsets.only(top: 30, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Wallet Balance',
                                  style: TextStyle(
                                    fontFamily: 'sfpro',
                                    color: lightColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    letterSpacing: 0.37,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "₦${walletBalance.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontFamily: 'sfpro',
                                    color: lightColor,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 40.0,
                                    letterSpacing: 0.36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        decoration: BoxDecoration(
                          color: primaryBackgroundColor.value,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(60.0),
                            topRight: Radius.circular(60.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefix: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/flag.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(" +234")
                                  ],
                                ),
                                labelText: "Enter your phone number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value!.length != 10) {
                                  return "Invalid phone number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _amount,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefix: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/flag.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text("₦")
                                  ],
                                ),
                                labelText: "Amount",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value!.length != 10) {
                                  return "Invalid phone number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedMerchant,
                              decoration: InputDecoration(
                                labelText: "Select Merchant",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              items: _dropdownItemsAirtime.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['val'],
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        item['image']!,
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(item['name']!),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMerchant = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            BottomRectangularBtn(
                              onTapFunc: () {
                                verifyFields();
                              },
                              btnTitle: 'Buy',
                              loadingText: 'Processing...',
                              isLoading: appController.loginLoader.value,
                              color: primaryColor.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
