// ignore_for_file: file_names, strict_top_level_inference

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilService {
  static bool firstLaunch = true;

  bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  static Future<void> getSavedData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey('firstLaunch')) {
      await sharedPref.setBool('firstLaunch', false);
    } else {
      UtilService.firstLaunch = sharedPref.getBool("firstLaunch")!;
    }
  }

  Future<void> copyToClipboard(String copiedText) async {
    await Clipboard.setData(ClipboardData(text: copiedText));
    Fluttertoast.showToast(
        msg: "Copied to clipboard",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF00D339),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showToast(message, {Color color = Colors.red}) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static bool deviceSizeAbove750(context) {
    Size size = MediaQuery.of(context).size;
    if (size.height > 750) {
      return true;
    } else {
      return false;
    }
  }

  String toFixed2DecimalPlaces(String? data, {int decimalPlaces = 2}) {
    if (data != null && data != 'null') {
      data = Decimal.parse(data).toString();
      List<String> values = data.split('.');
      if (values.length == 2 && values[1].length > decimalPlaces) {
        return '${values[0]}.${values[1].substring(0, decimalPlaces)}';
      } else {
        return data.toString();
      }
    }
    return '0';
  }

  void launchURL( url) async {
    try {
       await launchUrl(
          Uri.parse(url)
);
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
