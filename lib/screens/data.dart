// ignore_for_file: prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, unused_local_variable, avoid_print

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  AppController appController = Get.find<AppController>();

  TextEditingController _phoneContoller = TextEditingController();

  late TokenService tokenService;
  late VtuApi vtuApi;

  String? _selectedMerchant;
  String? _selectedPlan;

  List<Map<String, dynamic>> _dataPlans = [];
  Map<String, dynamic>? selectedPlanData;
  double walletBalance = 0.0;

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

  String generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> fetchDataPlans(String serviceId) async {
    try {
      final token = await tokenService.getToken();

      final response = await vtuApi.getDataVariations(token!, serviceId);

      if (response["success"] == true) {
        final plans = response["data"];

        setState(() {
          _dataPlans = List<Map<String, dynamic>>.from(plans)
              .where((plan) => plan["availability"] == "Available")
              .toList();

          // sort plans by price
          _dataPlans.sort((a, b) => double.parse(a["reseller_price"])
              .compareTo(double.parse(b["reseller_price"])));
        });
      }
    } catch (e) {
      print("Error fetching plans: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: appBgGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Data",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor.value,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor.value,
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
                  /// WALLET BALANCE
                  Container(
                    height: 210,
                    padding:
                        const EdgeInsets.only(top: 30, left: 16, right: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Wallet Balance',
                          style: TextStyle(
                            fontFamily: 'sfpro',
                            color: lightColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "₦${walletBalance.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: 'sfpro',
                            color: lightColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// FORM
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        color: primaryBackgroundColor.value,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),

                          /// PHONE
                          TextFormField(
                            controller: _phoneContoller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefix: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'images/flag.png',
                                    width: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text("+234"),
                                ],
                              ),
                              labelText: "Enter phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// NETWORK
                          DropdownButtonFormField<String>(
                            value: _selectedMerchant,
                            decoration: InputDecoration(
                              labelText: "Select Network",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _dropdownItemsAirtime.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Row(
                                  children: [
                                    Image.asset(
                                      item['image']!,
                                      width: 24,
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
                                _selectedPlan = null;
                              });

                              fetchDataPlans(value!);
                            },
                          ),

                          const SizedBox(height: 20),

                          /// DATA PLANS
                          DropdownButtonFormField<String>(
                            value: _selectedPlan,
                            decoration: InputDecoration(
                              labelText: "Choose Data Plan",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _dataPlans.map((plan) {
                              return DropdownMenuItem<String>(
                                value: plan["variation_id"].toString(),
                                child: Text(
                                  "${plan["data_plan"]} - ₦${plan["price"]}",
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPlan = value;

                                selectedPlanData = _dataPlans.firstWhere(
                                    (plan) =>
                                        plan["variation_id"].toString() ==
                                        value);
                              });
                            },
                          ),

                          const SizedBox(height: 50),

                          /// BUY BUTTON
                          BottomRectangularBtn(
                            onTapFunc: () async {
                              if (_phoneContoller.text.isEmpty ||
                                  _selectedMerchant == null ||
                                  selectedPlanData == null) {
                                Get.snackbar("Please complete the form", "");
                                return;
                              }

                              try {
                                appController.loginLoader.value = true;

                                final token = await tokenService.getToken();

                                final requestId = generateRequestId();

                                final phone = "234${_phoneContoller.text}";

                                final amount = selectedPlanData!["price"];

                                final serviceId =
                                    selectedPlanData!["service_id"].toString();

                                final result = await vtuApi.buyData(
                                  token!,
                                  requestId,
                                  phone,
                                  amount,
                                  serviceId,
                                );

                                Get.snackbar(
                                  "Success",
                                  "Data purchase successful",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                print(e);
                              } finally {
                                appController.loginLoader.value = false;
                              }
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
    );
  }
}
