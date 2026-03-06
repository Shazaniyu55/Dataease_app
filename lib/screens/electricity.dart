// ignore_for_file: sized_box_for_whitespace, prefer_final_fields, deprecated_member_use

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ElectricScreen extends StatefulWidget {
  const ElectricScreen({super.key});

  @override
  State<ElectricScreen> createState() => _ElectricScreenState();
}

class _ElectricScreenState extends State<ElectricScreen> {
  AppController appController = Get.find<AppController>();
  TextEditingController _meterNumber = TextEditingController();
  late TokenService tokenService;
  late VtuApi vtuApi;
  double walletBalance = 0.0;

  String? _selectedMerchant;
  String? _selectedMeterNumber;
  bool isVerifying = false;
  Map<String, dynamic>? verifiedCustomer;

  final List<Map<String, String>> _dropdownElectricItems = [
    {"val": "1", "name": "Abuja(AEDC)"},
    {"val": "2", "name": "Benin(BEDC)"},
    {"val": "3", "name": "Eko(EKEDC)"},
    {"val": "4", "name": "Enugu(EEDC)"},
    {"val": "5", "name": "Ibadan(IBEDC)"},
    {"val": "6", "name": "Ikeja(IKEDC)"},
    {"val": "7", "name": "Jos(JED)"},
    {"val": "8", "name": "Kaduna(KAEDCO)"},
    {"val": "9", "name": "Kano(KEDCO)"},
    {"val": "10", "name": "Portharcourt(PHED)"}
  ];

  final List<Map<String, String>> _dropdownMeterItems = [
    {"val": "1", "name": "PrePaid"},
    {"val": "2", "name": "PostPaid"},
  ];

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
      if (token != null) await _loadBalance(token);
    } catch (e) {
      print("Dashboard init error: $e");
    }
  }

  Future<void> _loadBalance(String token) async {
    try {
      final result = await vtuApi.checkBalance(token);
      setState(() {
        walletBalance =
            double.tryParse(result["data"]["balance"].toString()) ?? 0.0;
      });
    } catch (e) {
      print("Error fetching balance: $e");
    }
  }

  Future<void> verifyCustomerHandler() async {
    if (_selectedMerchant == null ||
        _selectedMeterNumber == null ||
        _meterNumber.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isVerifying = true;
      verifiedCustomer = null;
    });

    try {
      final token = await tokenService.getToken();
      final response = await vtuApi.verifyCustomer(
        token!,
        _meterNumber.text.trim(),
        _selectedMerchant!,
        _selectedMeterNumber!,
      );

      setState(() {
        verifiedCustomer = response["data"];
      });

      Get.snackbar(
        "Success",
        "Customer verified: ${verifiedCustomer!["name"] ?? "Unknown"}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Verification error: $e");
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: appBgGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:
              const Text("Electricity", style: TextStyle(color: Colors.white)),
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
                  // Wallet balance
                  Container(
                    height: 210,
                    padding:
                        const EdgeInsets.only(top: 30, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text('Wallet Balance',
                            style: TextStyle(
                                color: lightColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                        const SizedBox(height: 20),
                        Text("₦${walletBalance.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: lightColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 40)),
                      ],
                    ),
                  ),

                  // Form
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      decoration: BoxDecoration(
                        color: primaryBackgroundColor.value,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(60.0),
                            topRight: Radius.circular(60.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),

                          // Electric company
                          DropdownButtonFormField<String>(
                            value: _selectedMerchant,
                            decoration: InputDecoration(
                              labelText: "Choose Electric Company",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            items: _dropdownElectricItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Text(item['name']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMerchant = value;
                                verifiedCustomer = null;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Meter type
                          DropdownButtonFormField<String>(
                            value: _selectedMeterNumber,
                            decoration: InputDecoration(
                              labelText: "Choose Meter Type",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            items: _dropdownMeterItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Text(item['name']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMeterNumber = value;
                                verifiedCustomer = null;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Meter number
                          TextFormField(
                            controller: _meterNumber,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Meter Number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 16),
                            ),
                          ),

                          const SizedBox(height: 20),

//                          BottomRectangularBtn(
//   onTapFunc: verifyCustomerHandler, // call the function
//   btnTitle: 'Verify Customer',
//   loadingText: 'Verifying...',
//   isLoading: isVerifying, // already bool, no null
//   color: primaryColor.value,
// ),


ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor.value,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(double.infinity, 50), // full width, 50 height
  ),
  onPressed: isVerifying ? null : verifyCustomerHandler,
  child: isVerifying
      ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 77, 65, 243),
            strokeWidth: 2.5,
          ),
        )
      : const Text(
          "Verify Customer",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
),

                          const SizedBox(height: 20),

                          // Show verified info
                          if (verifiedCustomer != null)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Customer Name: ${verifiedCustomer!["name"] ?? "Unknown"}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "Address: ${verifiedCustomer!["address"] ?? "N/A"}"),
                                  Text(
                                      "Meter Type: ${verifiedCustomer!["meter_type"] ?? "N/A"}"),
                                ],
                              ),
                            )
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
