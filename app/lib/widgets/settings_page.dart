import 'dart:io';
import 'package:app/colors/our_colors.dart';
import 'package:app/cubit/theme_setter_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool status = false;
  bool changeDisplayTheme = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 58,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "More",
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 582,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Preference",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/phonelink_setup.png",
                height: 20,
                width: 20,
                color: Theme.of(context).primaryColor,
                fit: BoxFit.fill,
              ),
              title: Text(
                "System Preference",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: adaptiveSwitch(),
            ),
          ],
        ),
      ),
    );
  }

  Widget adaptiveSwitch() {
    return Platform.isIOS
        ? CupertinoSwitch(
            value: status,
            onChanged: _switchOnchanged,
            activeColor: AppColors.switchOn,
            trackColor: AppColors.switchOff,
          )
        : Switch(
            value: status,
            onChanged: _switchOnchanged,
            activeColor: AppColors.switchOn,
            inactiveTrackColor: AppColors.switchOff,
          );
  }

  Future<void> _switchOnchanged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isDarkModeSelected = prefs.getBool('isDarkModeSelected');
    bool switchMode = isDarkModeSelected == null ? true : !isDarkModeSelected;
    // update the state
    context.read<ThemeSetterCubit>().setThemeMode(switchMode);
    // update changeDisplayTheme
    await prefs.setBool('isDarkModeSelected', switchMode);

    setState(() {
      changeDisplayTheme = switchMode;
      status = !status;
    });
  }
}
