import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_setter_state.dart';

class ThemeSetterCubit extends Cubit<ThemeSetterState> {
  ThemeSetterCubit() : super(ThemeSetterInitial());

  ThemeMode themeToUse = ThemeMode.light;

  setThemeMode(bool isDarkModeSelected) async {
    // print(isDarkModeSelected);

    // save the selected theme
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'isDarkModeSelected', isDarkModeSelected ? true : false);

    isDarkModeSelected ? emit(SetDarkAppTheme()) : emit(SetLightAppTheme());
  }
}
