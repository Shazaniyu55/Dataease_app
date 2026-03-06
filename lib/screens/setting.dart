// ignore_for_file: unused_import, unnecessary_import, unused_element, prefer_final_fields, use_super_parameters, duplicate_ignore, unused_element_parameter
import 'package:dataapp/constant/colors.dart';
import 'package:dataapp/controller/themeController.dart';
import 'package:dataapp/helper/navigator.dart';
import 'package:dataapp/screens/home/dashboard.dart';
import 'package:dataapp/screens/kycScreen.dart';
import 'package:dataapp/screens/otpScreen.dart';
import 'package:dataapp/screens/profile.dart';
import 'package:dataapp/screens/verify.dart';
import 'package:dataapp/widgets/commonwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage2 extends StatefulWidget {
  // ignore: use_super_parameters
  const SettingsPage2({Key? key}) : super(key: key);

  @override
  State<SettingsPage2> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<SettingsPage2> {
  @override
  Widget build(BuildContext context) {
    Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                children: [
                  const _CustomListTile(
                      title: "My Profile",
                      icon: Icons.person_outline_rounded,
                      iconColor:
                          Colors.blue, // Set your desired icon color here
                      trailing: Icons.arrow_forward_ios_rounded,
                      destinationPage: Profile() // Icon on the right side
                      ),
                  const Divider(),
                 
                  // Obx(() => _CustomSwitchTile(
                  //       title: "Dark Mode",
                  //       icon: Icons.dark_mode_outlined,
                  //       value: themeController.isDarkMode.value,
                  //       onChanged: themeController.toggleTheme,
                  //     )),
                   const _CustomListTile(
                      title: "Kyc",
                      icon: Icons.file_copy_outlined,
                      iconColor:
                          Colors.blue, // Set your desired icon color here
                      trailing: Icons.arrow_forward_ios_rounded,
                      destinationPage: KycScreen() // Icon on the right side
                      ),
                  const Divider(),

                  const _CustomListTile(
                      title: "Verify Email",
                      icon: Icons.email_outlined,
                      iconColor:
                          Colors.blue, // Set your desired icon color here
                      trailing: Icons.arrow_forward_ios_rounded,
                      destinationPage: VerifyEmalScreen() // Icon on the right side
                      ),
                 
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomSwitchTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomSwitchTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      secondary: Icon(icon, color: primaryColor.value),
      value: value,
      onChanged: onChanged,
    );
  }
}

// ignore: must_be_immutable
class _SignOutTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? trailing;
  Function? onTap; // Destination page for navigation

  _SignOutTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    required MaterialColor iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        icon,
        color: primaryColor.value,
      ),
      trailing: Icon(trailing),
      onTap: () {
        onTap?.call();
      },
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? trailing;
  final Widget destinationPage; // Destination page for navigation

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    required MaterialColor iconColor,
    required this.destinationPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        icon,
        color: primaryColor.value,
      ),
      trailing: Icon(trailing),
      onTap: () {
        if (destinationPage is CustomBottomSheet) {
          CustomBottomSheet.showSignOutBottomSheet(context);
        } else {
          changeScreen(context, destinationPage);
        }
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Are you sure you want to sign out?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Click 'Confirm' to sign out from your account.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close the bottom sheet
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your sign-out logic here
                  Get.back(); // Close the bottom sheet after action
                },
                child: const Text("Confirm"),
              ),
            ],
          )
        ],
      ),
    );
  }

  static void showSignOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          minChildSize:
              0.25, // Minimum height of the bottom sheet (10% of the screen)
          maxChildSize:
              0.4, // Maximum height of the bottom sheet (20% of the screen)
          initialChildSize: 0.25,
          builder: (context, controller) {
            return const CustomBottomSheet();
          },
        );
      },
    );
  }
}