// ignore_for_file: unused_field, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, avoid_print

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CableScreen extends StatefulWidget {
  const CableScreen({super.key});

  @override
  State<CableScreen> createState() => _CableScreenState();
}

class _CableScreenState extends State<CableScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TokenService tokenService;
  double walletBalance = 0.0;
  late VtuApi vtuApi;

  AppController appController = Get.find<AppController>();
  TextEditingController _amount = TextEditingController();

  String? _selectedMerchant;
  final List<Map<String, String>> _dropdownItemsAirtime = [
    {
      "val": "1",
      "name": "DSTV",
    },
    {
      "val": "2",
      "name": "GOTV",
    },
    {
      "val": "3",
      "name": "STARTIMES",
    },
  ];

  String? _selectedPlan;

  final List<Map<String, String>> _dropdownItemsCablePlan = [
    {"val": "1", "plans": "GREAT WALL"},
    {"val": "2", "plans": "PADI"},
    {"val": "3", "plans": "YANGA"},
    {"val": "4", "plans": "CONFAM"},
    {"val": "5", "plans": "ASIA"},
    {"val": "6", "plans": "COMPACT"},
    {"val": "7", "plans": "COMPACT PLUS"},
    {"val": "8", "plans": "PREMIUM"},
    {"val": "9", "plans": "PREMIUM-ASIA"},
    {"val": "10", "plans": "SMALLIE"},
    {"val": "11", "plans": "JINJA"},
    {"val": "12", "plans": "JOLLI"},
    {"val": "13", "plans": "MAX"},
    {"val": "14", "plans": "NOVA"},
    {"val": "15", "plans": "BASIC"},
    {"val": "16", "plans": "SMART"},
    {"val": "17", "plans": "CLASSIC"},
    {"val": "18", "plans": "SUPER"},
    {"val": "19", "plans": "PREMIUM-FRENCH"},
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
            "Cable",
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
                          DropdownButtonFormField<String>(
                            value: _selectedMerchant,
                            decoration: InputDecoration(
                              labelText: "Choose Cable",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: _dropdownItemsAirtime.map((item) {
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
                            value: _selectedPlan,
                            decoration: InputDecoration(
                              labelText: "Choose Package/Bouquet",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: _dropdownItemsCablePlan.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['val'],
                                child: Row(
                                  children: <Widget>[
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
                            height: 20,
                          ),
                          TextFormField(
                            controller: _amount,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "SmartCard Number",
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
