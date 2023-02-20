import 'dart:developer';
import 'package:app/cubit/theme_setter_cubit.dart';
import 'package:app/widgets/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // create instance of SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // before app load: get the theme set by user (return null if theme was not changed by user)
  bool? isDarkModeSelected = prefs.getBool('isDarkModeSelected');

  /**
   * Using BlocProvider, so we can use it to set and update our app theme
   */
  runApp(BlocProvider(
    create: (context) => ThemeSetterCubit(),
    child: MyApp(isDarkModeSelected: isDarkModeSelected ?? false),
  ));
}

class MyApp extends StatelessWidget {
  bool? isDarkModeSelected;
  MyApp({Key? key, this.isDarkModeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get the theme set by user
    bool theSelectedTheme = isDarkModeSelected ?? false;
    if (theSelectedTheme) {
      // set the theme from previous user change
      context.read<ThemeSetterCubit>().setThemeMode(theSelectedTheme);
    }

    // listen for changes when a theme is changed
    context.select((ThemeSetterCubit b) => b.state is SetDarkAppTheme
        ? log("current theme State: SetDarkAppTheme: dark theme")
        : log("current theme State: SetLightAppTheme: light theme"));

    context.select((ThemeSetterCubit b) => b.state is SetDarkAppTheme
        ? isDarkModeSelected = true
        : isDarkModeSelected = false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theSelectedTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primaryColor:
            Colors.black, // to be used by customTextStyle() to font color
        primarySwatch: Colors.blueGrey,

        iconTheme: const IconThemeData(color: Colors.black),
        brightness: Brightness
            .light, // The color is light and it wiil set dark text color to achieve readable contrast.
      ),
      darkTheme: ThemeData(
        primaryColor:
            Colors.white, // to be used by customTextStyle() to font color
        primarySwatch: Colors.blueGrey,

        iconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness
            .dark, // The color is dark and it wiil set light text color to achieve readable contrast.
      ),
      home: const SettingsPage(),
    );
  }
}
