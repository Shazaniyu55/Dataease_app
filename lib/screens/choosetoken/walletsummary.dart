// ignore_for_file: file_names, prefer_final_fields, sized_box_for_whitespace, unnecessary_string_interpolations, sort_child_properties_last, use_super_parameters, deprecated_member_use, avoid_print

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WalletSummary extends StatefulWidget {
  const WalletSummary({Key? key, this.fromPage}) : super(key: key);
  final String? fromPage;

  @override
  State<WalletSummary> createState() => _WalletSummaryState();
}

class _WalletSummaryState extends State<WalletSummary> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final appController = Get.find<AppController>();
  late TokenService tokenService;
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

      await _loadBalance(token);
      await _loadTransaction(token);
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

  Future<void> _loadTransaction(String token) async {
    try {
      final result = await vtuApi.getTransactions(token);

      if (result['status'] == "success" && result['data'] != null) {
        // Update the userBalance transactions in the controller
        appController.userBalance['transactions'] = result['data'];

        // Optional: If you want to update wallet balance too
        // appController.userBalance['balance'] = result['balance'] ?? appController.userBalance['balance'];
      }

      setState(() {}); // Refresh UI
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: Scaffold(
        backgroundColor: primaryColor.value,
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 APP BAR
              Container(
                height: 110,
                padding: const EdgeInsets.only(top: 70),
                child: CommonWidgets()
                    .appBar(hasBack: true, title: "Wallet Summary"),
              ),

              /// 🔹 BODY
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: primaryBackgroundColor.value,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        /// 🔥 BALANCE CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.value,
                                primaryColor.value.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "₦${walletBalance.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //const SizedBox(height: 25),

                        /// 🔹 QUICK ACTIONS
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     _actionButton(Icons.add, "Fund"),
                        //     _actionButton(Icons.send, "Transfer"),
                        //     _actionButton(Icons.arrow_downward, "Withdraw"),
                        //   ],
                        // ),

                        const SizedBox(height: 30),

                        /// 🔹 TITLE
                        Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// 🔥 TRANSACTION LIST
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: appController
                                  .userBalance['transactions']?.length ??
                              0,
                          itemBuilder: (context, i) {
                           
                            var tx = appController.userBalance['transactions'][i];

                            bool isSuccess = tx['status'] == "success";
                      Color iconColor = isSuccess ? Colors.green : Colors.red;
                      IconData icon = isSuccess ? Icons.check_circle : Icons.error;
                      // Format date nicely
                  String date = tx['createdAt'] != null
                      ? DateTime.parse(tx['createdAt']).toLocal().toString().split(".")[0]
                      : "";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.05),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isSuccess
                                        ? iconColor.withOpacity(0.1)
                                        : iconColor.withOpacity(0.1),
                                    child: Icon(
                                      isSuccess
                                          ? icon
                                          : icon,
                                      color:
                                          isSuccess ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${tx['type'].toString().toUpperCase()} - ${tx['network'].toString().toUpperCase()}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                              Text(
                                "Phone: ${tx['phoneOrAccount']}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: labelColor.value,
                                ),
                              ),
                              Text(
                                "Request ID: ${tx['reference']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: labelColor.value.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                "Date: $date",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: labelColor.value.withOpacity(0.7),
                                ),
                              ),
                            
                                      
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "₦${tx['amount']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isSuccess ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 ACTION BUTTON
// Widget _actionButton(IconData icon, String label) {
//   return Column(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: primaryColor.value.withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           color: primaryColor.value,
//         ),
//       ),
//       const SizedBox(height: 8),
//       Text(
//         label,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       )
//     ],
//   );
// }
