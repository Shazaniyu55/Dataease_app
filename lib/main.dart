import 'package:dataapp/controller/appController.dart';
import 'package:dataapp/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appController = Get.put(AppController());
  await appController.loadToken();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final appController = Get.put(AppController());
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
        title: 'DataSubcription App',
        theme: ThemeData(
            primaryColor: const Color(0xff27C19F),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xff27C19F),
            )),
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
  }
}

class MyBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
