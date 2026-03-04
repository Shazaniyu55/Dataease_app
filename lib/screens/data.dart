// ignore_for_file: prefer_final_fields, sized_box_for_whitespace, deprecated_member_use

import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
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

  String? _selectedMerchant;

  final List<Map<String, String>> _dropdownItemsAirtime = [
    {"val": "1", "name": "9Mobile", "image": "images/9mobile.png"},
    {"val": "2", "name": "Airtel", "image": "images/airtel.png"},
    {"val": "3", "name": "Glo", "image": "images/glo.png"},
    {"val": "4", "name": "MTN", "image": "images/download.png"},
  ];

  String? _selectedPlan;

  final List<Map<String, String>> _dropdownItemsDataPlans = [
    {"val": "1", "plans": "500MB(Gift)-30Days"},
    {"val": "2", "plans": "1GB(Gift)-30Days"},
    {"val": "3", "plans": "2GB(Gift)-30Days"},
    {"val": "4", "plans": "3GB(Gift)-30Days"},
    {"val": "5", "plans": "5GB(Gift)-30Days"},
    {"val": "6", "plans": "10GB(Gift)-30Days"},
    {"val": "7", "plans": "15GB(Gift)-30Days"},
    {"val": "8", "plans": "500MB-30Days"},
    {"val": "9", "plans": "1GB-30Days"},
    {"val": "10", "plans": "2GB-30Days"},
    {"val": "11", "plans": "3GB-30Days"},
    {"val": "12", "plans": "5GB-30Days"},
    {"val": "13", "plans": "10GB-30Days"},
    {"val": "14", "plans": "40GB-30Days"},
    {"val": "15", "plans": "750MB-14Days"},
    {"val": "16", "plans": "1.5GB-30Days"},
    {"val": "17", "plans": "2GB-2Days"},
    {"val": "18", "plans": "4.5GB-30Days"},
    {"val": "19", "plans": "2.5GB-30Days"},
    {"val": "20", "plans": "11GB-30Days"},
    {"val": "21", "plans": "15GB-30Days"},
  ];

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
            // Status bar color
            statusBarColor: primaryColor.value,
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: Obx(() => SingleChildScrollView(
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
                                  '₦${0.0}',
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
                              controller: _phoneContoller,
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
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedPlan,
                              decoration: InputDecoration(
                                labelText: "Choose Data Plans",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              items: _dropdownItemsDataPlans.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['val'],
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(width: 10),
                                      Text(item['plans']!),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPlan = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            BottomRectangularBtn(
                              onTapFunc: () {},
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
            )),
      ),
    );
  }
}
