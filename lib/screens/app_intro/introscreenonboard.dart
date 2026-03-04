// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/screens/app_intro/introdudction.dart';
import 'package:dataapp/screens/signup.dart';
import 'package:dataapp/widgets/bottomrectangularbtn.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IntroScreenOnboarding extends StatefulWidget {
  final List<Introduction>? introductionList;

  const IntroScreenOnboarding({
    Key? key,
    this.introductionList,
  }) : super(key: key);

  @override
  _IntroScreenOnboardingState createState() =>
      _IntroScreenOnboardingState();
}

class _IntroScreenOnboardingState
    extends State<IntroScreenOnboarding> {
  final PageController _pageController =
      PageController(initialPage: 0);

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor.value,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
        ),
      ),

      body: Column(
        children: [

          // 🔵 Top Colored Header
          Container(
            height: 100,
            width: double.infinity,
            color: primaryColor.value,
            alignment: Alignment.bottomCenter,
            child: CommonWidgets()
                .appBar(title: 'DataEase', hasBack: false),
          ),

          // ⚪ White Content Area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryBackgroundColor.value,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 30),
                child: Column(
                  children: [

                    // 🔘 Indicators
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        _indicator(_currentPage == 0),
                        _indicator(_currentPage == 1),
                        _indicator(_currentPage == 2),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 📄 PageView
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children:
                            widget.introductionList!,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔘 Button
                    _currentPage !=
                            widget.introductionList!
                                    .length -
                                1
                        ? BottomRectangularBtn(
                            onTapFunc: () {
                              _pageController.nextPage(
                                duration: const Duration(
                                    milliseconds: 400),
                                curve: Curves.ease,
                              );
                            },
                            btnTitle: 'Next',
                          )
                        : BottomRectangularBtn(
                            onTapFunc: () {
                              Get.to(
                                  const SignupScreen());
                            },
                            btnTitle: 'Continue',
                          ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin:
          const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isActive
            ? primaryColor.value
            : const Color(0xFFEAEAEA),
      ),
    );
  }
}