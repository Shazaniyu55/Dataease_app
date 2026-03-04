// ignore_for_file: prefer_final_fields, sized_box_for_whitespace, deprecated_member_use

import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BettingScreen extends StatefulWidget {
  const BettingScreen({super.key});

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  AppController appController = Get.find<AppController>();
  final TextEditingController _phoneContoller = TextEditingController();

  String? _selectedMerchant;

  final List<Map<String, String>> _dropdownItemsAirtime = [
    {
      "val": "1",
      "name": "1XBet",
    },
    {
      "val": "2",
      "name": "BangBet",
    },
    {
      "val": "3",
      "name": "Bet9ja",
    },
    {
      "val": "4",
      "name": "BetKing",
    },
    {
      "val": "5",
      "name": "BetLand",
    },
    {
      "val": "6",
      "name": "BetLion",
    },
    {
      "val": "7",
      "name": "BetWay",
    },
    {
      "val": "8",
      "name": "CloudBet",
    },
    {
      "val": "9",
      "name": "LiveScoreBet",
    },
    {
      "val": "10",
      "name": "MerryBet",
    },
    {
      "val": "11",
      "name": "NaijaBet",
    },
    {
      "val": "12",
      "name": "NairaBet",
    },
    {
      "val": "13",
      "name": "SupaBet",
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
            "Betting",
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
                          TextFormField(
                            controller: _phoneContoller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Enter Customer (account)ID",
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
                              labelText: "Choose Betting Provider",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: _dropdownItemsAirtime.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Row(
                                  children: <Widget>[
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
