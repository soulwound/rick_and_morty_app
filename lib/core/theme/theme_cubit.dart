import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box settingsBox;

  ThemeCubit(this.settingsBox) : super(_getInitialTheme(settingsBox));

  static ThemeMode _getInitialTheme(Box box) {
    final themeString = box.get('theme', defaultValue: 'light');
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      settingsBox.put('theme', 'dark');
    }
    else {
      emit(ThemeMode.light);
      settingsBox.put('theme', 'light');
    }
  }
}