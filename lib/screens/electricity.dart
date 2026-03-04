// ignore_for_file: sized_box_for_whitespace, prefer_final_fields, deprecated_member_use

import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
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

  String? _selectedMerchant;

  final List<Map<String, String>> _dropdownElectricItems = [
    {
      "val": "1",
      "name": "Abuja(AEDC)",
    },
    {
      "val": "2",
      "name": "Benin(BEDC)",
    },
    {
      "val": "3",
      "name": "Eko(EKEDC)",
    },
    {
      "val": "4",
      "name": "Enugu(EEDC)",
    },
    {
      "val": "5",
      "name": "Ibadan(IBEDC)",
    },
    {
      "val": "6",
      "name": "Ikeja(IKEDC)",
    },
    {
      "val": "7",
      "name": "Jos(JED)",
    },
    {
      "val": "8",
      "name": "Kaduna(KAEDCO)",
    },
    {
      "val": "9",
      "name": "Kano(KEDCO)",
    },
    {
      "val": "10",
      "name": "Portharcourt(PHED)",
    }
  ];

  String? _selectedMeterNumber;

  final List<Map<String, String>> _dropdownMeterItems = [
    {
      "val": "1",
      "name": "PrePaid",
    },
    {
      "val": "2",
      "name": "PostPaid",
    },
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
            "Electricity",
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
                          DropdownButtonFormField<String>(
                            value: _selectedMerchant,
                            decoration: InputDecoration(
                              labelText: "Choose Electric Company",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: _dropdownElectricItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Row(
                                  children: <Widget>[
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
                            value: _selectedMeterNumber,
                            decoration: InputDecoration(
                              labelText: "Choose Meter Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: _dropdownMeterItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Row(
                                  children: <Widget>[
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
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _meterNumber,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefix: const Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text("Enter your Meter Number")],
                              ),
                              labelText: "Meter Number",
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
          ),
        ),
      ),
    );
  }
}
