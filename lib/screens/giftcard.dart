import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';

class GiftCardWidget extends StatefulWidget {
  final String title;
  final String brandImage;
  final String amount;
  final VoidCallback? onBuy;

  const GiftCardWidget({
    Key? key,
    required this.title,
    required this.brandImage,
    required this.amount,
    this.onBuy,
  }) : super(key: key);

  @override
  State<GiftCardWidget> createState() => _GiftCardWidgetState();
}

class _GiftCardWidgetState extends State<GiftCardWidget> {
  bool isLoading = false;

  void handleBuy() async {
    if (widget.onBuy != null) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 800));

      widget.onBuy!();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      height: 170,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.value,
            const Color.fromARGB(255, 36, 72, 220),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: appShadow,
      ),
      child: Stack(
        children: [
          /// Background icon
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.card_giftcard,
              size: 120,
              color: Colors.white.withOpacity(0.08),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Brand row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      widget.brandImage,
                      width: 40,
                    ),
                    Text(
                      "Gift Card",
                      style: TextStyle(
                        color: lightColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// Amount
                Text(
                  widget.amount,
                  style: TextStyle(
                    color: lightColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                /// Title
                Text(
                  widget.title,
                  style: TextStyle(
                    color: lightColor.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 15),

                /// Buy button
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: handleBuy,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryColor.value,
                              ),
                            )
                          : Text(
                              "Buy Now",
                              style: TextStyle(
                                color: primaryColor.value,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}