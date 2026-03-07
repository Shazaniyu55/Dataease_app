// ignore_for_file: use_super_parameters, sized_box_for_whitespace, deprecated_member_use, avoid_print

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/airtime.dart';
import 'package:dataapp/screens/betting.dart';
import 'package:dataapp/screens/cable.dart';
import 'package:dataapp/screens/chat.dart';
import 'package:dataapp/screens/choosetoken/transactionsmmary.dart';
import 'package:dataapp/screens/choosetoken/walletsummary.dart';
import 'package:dataapp/screens/data.dart';
import 'package:dataapp/screens/electricity.dart';
import 'package:dataapp/screens/giftcard.dart';
import 'package:dataapp/screens/giftcardMarket.dart';
import 'package:dataapp/screens/listvendors.dart';
import 'package:dataapp/screens/notification.dart';
import 'package:dataapp/screens/profile.dart';
import 'package:dataapp/screens/setting.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TokenService tokenService;
  int currentMax = 1;
  AppController appController = Get.find<AppController>();
  double walletBalance = 0.0;
  late VtuApi vtuApi;

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

      await _loadUserProfile(token, userId);
      await _loadBalance(token);
    } catch (e) {
      print("Dashboard init error: $e");
    }
  }

  Future<void> _loadUserProfile(String token, String userId) async {
    try {
      final profile = await vtuApi.getUserProfile(token, userId);

      //print("Profile: $profile");

      setState(() {
        // Example
        appController.userName.value = profile["fullName"];
        appController.email.value = profile["email"];
        appController.img.value = profile["profilePic"] ?? '';
      });
    } catch (e) {
      Get.showSnackbar("$e" as GetSnackBar);
      //print("Profile error: $e");
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

  

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
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
            backgroundColor: primaryColor.value,
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Theme.of(context).primaryColor,
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Obx(() => Text(
                        appController.userName.value.isEmpty
                            ? "Loading..."
                            : appController.userName.value,
                        style: const TextStyle(color: Colors.white),
                      )),
                  accountEmail: Obx(() => Text(
                        appController.userName.value.isEmpty
                            ? "Loading..."
                            : appController.email.value,
                        style: const TextStyle(color: Colors.white),
                      )),
                  currentAccountPicture: Obx(() => CircleAvatar(
                        backgroundImage: NetworkImage(appController.img.value),
                      )),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color(0xff1f005c),
                        Color.fromARGB(255, 59, 15, 219),
                        Color.fromARGB(255, 65, 129, 223),
                        Color.fromARGB(255, 21, 132, 192),
                        Color.fromARGB(255, 55, 132, 225),
                        Color.fromARGB(255, 100, 123, 239),
                        Color.fromARGB(255, 44, 47, 227),
                        Color.fromARGB(255, 107, 171, 255),
                      ],
                    ),
                    image: DecorationImage(
                      image: NetworkImage(appController.img.value.isNotEmpty
                          ? appController.img.value
                          : "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: const Text("Settings"),
                  onTap: () {
                    Get.to(const SettingsPage2());
                  },
                ),

                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notification_add,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: const Text("Notification"),
                  onTap: () {
                    Get.to(const NotificationScreen());
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_3,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: const Text("Profile"),
                  onTap: () {
                    Get.to(const Profile());
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(
                    Icons.chat,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: const Text("Data Vendors"),
                  onTap: () {
                    Get.to(const ListOfVendors());
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: const Text("Log out"),
                  onTap: () async {
                    await vtuApi.logout();
                  },
                ),
              ],
            ),
          ),
          body: Obx(
            () => Container(
              height: Get.height,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 210,
                        padding:
                            const EdgeInsets.only(top: 30, left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
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
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          decoration: BoxDecoration(
                            color: primaryBackgroundColor.value,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 60),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  runSpacing: 15,
                                  children: [
                                    _buildCard(
                                        context, "images/phone.png", "Airtime",
                                        () {
                                      Get.to(const AirtimeScreen());
                                    }),
                                    _buildCard(context, "images/data.png", "Data",
                                        () {
                                      Get.to(const DataScreen());
                                    }),
                                    _buildCard(
                                        context, "images/light.png", "Electric",
                                        () {
                                      Get.to(const ElectricScreen());
                                    }),
                                    _buildCard(context, "images/tv.png", "Cable",
                                        () {
                                      Get.to(const CableScreen());
                                    }),
                                    _buildCard(context, "images/bet.png", "Betting",
                                        () {
                                      Get.to(const BettingScreen());
                                    }),
                            
                                    _buildCard(context, "images/coin.png", "Gift cards",
                                        () {
                                      Get.to(const GiftCardMarketplace());
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 170,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: Get.width - 32,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: cardColor.value,
                          boxShadow: appShadow,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            _dashBTns(
                              svg: 'wallet',
                              btnText: 'Fund wallet',
                              onTap: () {
                                CommonWidgets()
                                    .selectWithdrawBottomSheet(context);
                              },
                            ),
                            const SizedBox(width: 20),
                            _dashBTns(
                              svg: 'transac',
                              btnText: 'Transactions',
                              onTap: () {
                                Get.to(const TransactionSummary());
                              },
                            ),
                            _dashBTns(
                              svg: 'sum',
                              btnText: 'Summary',
                              onTap: () {
                                Get.to(const WalletSummary());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor.value,
            onPressed: () {
              Get.to(const SingleChat());
            },
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String imagePath, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: (MediaQuery.of(context).size.width - 70) / 3,
          height: 110,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffD8D9E4)),
                ),
                child: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: primaryColor.value,
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                ),
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashBTns({String? svg, String? btnText, Function? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      'images/$svg.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$btnText',
                style: TextStyle(
                  fontFamily: 'sfpro',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  letterSpacing: 0.37,
                  color: inputFieldTextColor.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
