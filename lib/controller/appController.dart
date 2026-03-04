// ignore_for_file: file_names, library_prefixes, deprecated_member_use, strict_top_level_inference
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/services/tokenServie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final TokenService _tokenService = TokenService();

  var token = ''.obs;
  var isDark = false.obs;
  var enabledBiometric = false.obs;
  var selectedTabIndex = 1.obs;
  var selectedTabIndex1 = 0.obs;
  var theme = false.obs;
  var registerLoader = false.obs;
  var registerWithImportLoader = false.obs;
  var loginLoader = false.obs;
  var userWalletsLoader = false.obs;
  var getBalanceLoader = false.obs;
  var getNetworksLoader = false.obs;
  var getAllCoinsLoader = false.obs;
  var getTransactionsLoader = false.obs;
  var sendAmountLoader = false.obs;
  var getContactsLoader = false.obs;
  var importTokenLoader = false.obs;
  var changePassLoader = false.obs;
  var createNewWalletLoader = false.obs;
  var importWalletLoader = false.obs;

  var userName = ''.obs;
  var email = ''.obs;
  var img = ''.obs;
  var acctType = ''.obs;
  var phone = ''.obs;
  var verified = false.obs;

  var userBalance = <String, dynamic>{}.obs;
  var password = ''.obs;

  var getSwapTransactionsLoader = false.obs;
  var swapLoader = false.obs;
  var seeAll = false.obs;
  var hideBalance = false.obs;
  var selectedIndex = 0.obs;
  var selectedBOttomTabIndex = 0.obs;
  var updateProfileLoader = false.obs;
  var withdrawFiatLoader = false.obs;
  var withdrawCryptoLoader = false.obs;
  var swapCryptoLoader = false.obs;
  var verifyEmailLoader = false.obs;
  var getLoggedInUserLoader = false.obs;
  var getSwapQuoteLoader = false.obs;
  var verifyOtpLoader = false.obs;
  var forgotPassLoader = false.obs;
  var resetPassLoader = false.obs;
  var currenciesLoader = false.obs;
  var getFeeLoader = false.obs;

  var selectCurrenciesList = <String>[].obs;
  var userBalanceInNaira = ''.obs;
  var deleteProfileLoader = false.obs;

  var selectCoinIndex = 0.obs;
  var shoudApiCallsRun = false.obs;
  var errMsg = ''.obs;
  var shouldCallDashboardApi = true.obs;

  Future<void> loadToken() async {
    final savedToken = await _tokenService.getToken();

    if (savedToken != null) {
      token.value = savedToken;
    }
  }

  void changeTheme() {
    if (isDark.value) {
      primaryBackgroundColor.value = const Color(0xff101614);
      cardColor.value = const Color(0xff131C1A);
      chatBoxBg.value = const Color(0xff131C1A);
      inputFieldBackgroundColor.value = const Color(0xff131C1A);
      inputFieldTextColor.value = const Color(0xffcccccc);
      headingColor.value = const Color(0xffffffff);
      labelColor.value = const Color(0xffcccccc);
      appShadow.value = [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0).withOpacity(0.35),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ];
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    } else {
      headingColor.value = const Color(0xFF030319);
      primaryBackgroundColor.value = const Color(0xFFFFFFFF);
      inputFieldBackgroundColor.value = const Color(0xFFFAFAFA);
      inputFieldTextColor.value = const Color(0xFF1B2023);
      cardColor.value = const Color(0xFFFCFCFC);
      labelColor.value = const Color(0xFF6A6A6A);
      chatBoxBg.value = const Color(0xffF8F8F8);
      appShadow.value = [
        BoxShadow(
          color: const Color.fromRGBO(155, 155, 155, 15).withOpacity(0.15),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ];
    }
    Get.changeThemeMode(ThemeMode.light);
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
  }
}
