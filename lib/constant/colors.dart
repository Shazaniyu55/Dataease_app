// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

var primaryColor = const Color.fromARGB(255, 66, 99, 231).obs;
var primaryBackgroundColor = const Color(0xFFFFFFFF).obs;
var dividerColor = const Color(0xFFF2F2F2).obs;
var headingColor = const Color(0xFF030319).obs;
var labelColor = const Color(0xFF8F92A1).obs;
Color placeholderColor = const Color(0xff8F92A1);
var inputFieldTextColor = const Color(0xFF0F001C).obs;
var inputFieldBackgroundColor = const Color(0xFFFAFAFA).obs;
var listCardColor = const Color(0xFFFAFAFA).obs;

var chatBoxBg = const Color(0xffF8F8F8).obs;

Color btnTxtColor = const Color(0xFFFCFCFC);
Color errorTxtColor = const Color(0xFFFF0E41);
Color lightColor = const Color(0xFFFCFCFC);
var cardColor = const Color(0xFFFFFFFF).obs;
var greenCardColor = const Color(0xFF39B171).obs;
var redCardColor = const Color.fromARGB(255, 85, 168, 240).obs;
var chipChoiceColor = const Color.fromARGB(255, 130, 148, 237).withOpacity(0.1);
var bSheetbtnColor = const Color(0x0DF9895E).withOpacity(0.10);
var appBgGradient = const LinearGradient(
  begin: Alignment(0.0, 0.0),
  end: Alignment(0, -1),
  colors: [Color.fromARGB(255, 95, 176, 222), Color.fromARGB(255, 37, 98, 222)],
);

///////////history screen colors//////////////
var bgCintainerColor = const Color(0xff27C19F);
var bg2CintainerColor = const Color.fromARGB(255, 79, 141, 241);
var iconUpColor = const Color(0xffE34446);

var iconDownColor = const Color(0xff0C9D7D);

//////////////history/////////

var appShadow = [
  BoxShadow(
    color: const Color.fromRGBO(155, 155, 155, 15).withOpacity(0.15),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3), // changes position of shadow
  ),
].obs;

var homeCardBgShadow = [
  const BoxShadow(
    color: Color(0x00000000),
    offset: Offset(0.0, 4.0),
    blurRadius: 20.0,
  ),
].obs;
