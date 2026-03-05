import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/controller/themeController.dart';
import 'package:dataapp/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appController = Get.put(AppController());
  await appController.loadToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final appController = Get.put(AppController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(() {
      
      return GetMaterialApp(
          title: 'DataEase',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          transitionDuration: const Duration(milliseconds: 500),
          defaultTransition: Transition.rightToLeftWithFade,
          home: const SplashScreen());
    });
  }
}

class MyBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
