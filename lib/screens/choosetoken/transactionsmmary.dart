// ignore_for_file: file_names, prefer_final_fields, sized_box_for_whitespace, unnecessary_string_interpolations, sort_child_properties_last, use_super_parameters, invalid_use_of_protected_member, deprecated_member_use, avoid_print

import 'package:dataapp/assistant/assistant.dart';
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransactionSummary extends StatefulWidget {
  const TransactionSummary({Key? key, this.fromPage}) : super(key: key);
  final String? fromPage;

  @override
  State<TransactionSummary> createState() => _TransactionSummaryState();
}

class _TransactionSummaryState extends State<TransactionSummary> {
  final appController = Get.find<AppController>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TokenService tokenService;
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
        body: Obx(
          () => Container(
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 110,
                  padding: const EdgeInsets.only(top: 70),
                  child: CommonWidgets()
                      .appBar(hasBack: true, title: "Transaction Summary"),
                ),
                Expanded(
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: primaryBackgroundColor.value,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: appController.getBalanceLoader.value
        ? const Center(child: CircularProgressIndicator())
        : appController.userBalance['transactions'] == null ||
                appController.userBalance['transactions'].isEmpty
            ? Center(
                child: Text(
                  "No transactions yet",
                  style: TextStyle(
                    color: labelColor.value,
                    fontSize: 14,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                itemCount: appController.userBalance['transactions'].length,
                itemBuilder: (context, i) {
                  var tx = appController.userBalance['transactions'][i];

                  // Determine colors/icons based on status
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
                      color: cardColor.value,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: appShadow.value,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${tx['type'].toString().toUpperCase()} - ${tx['network'].toString().toUpperCase()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: headingColor.value,
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
                            fontSize: 14,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
