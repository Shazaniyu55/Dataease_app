import 'package:dataapp/screens/giftcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';

class GiftCardMarketplace extends StatefulWidget {
  const GiftCardMarketplace({Key? key}) : super(key: key);

  @override
  State<GiftCardMarketplace> createState() => _GiftCardMarketplaceState();
}

class _GiftCardMarketplaceState extends State<GiftCardMarketplace> {

  final List giftCards = [
    {"title": "Amazon", "image": "images/amazon.png", "amount": "₦10,000"},
    {"title": "Apple", "image": "images/apple.png", "amount": "₦25,000"},
  
  ];

  int getCrossAxisCount(double width) {
    if (width < 600) {
      return 2; // Mobile
    } else if (width < 1000) {
      return 3; // Tablet
    } else if (width < 1400) {
      return 4; // Small desktop
    } else {
      return 5; // Large web screens
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,

      appBar: AppBar(
        title: const Text("Gift Cards"),
        backgroundColor: primaryColor.value,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {

          int crossAxisCount = getCrossAxisCount(constraints.maxWidth);

          return Column(
            children: [

              /// Search
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: inputFieldBackgroundColor.value,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search gift cards",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              /// Responsive Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: giftCards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {

                    final card = giftCards[index];

                    return GiftCardWidget(
                      title: card["title"],
                      brandImage: card["image"],
                      amount: card["amount"],
                      onBuy: () {
                        Get.snackbar(
                          "Purchase",
                          "Buying ${card["title"]} gift card",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}