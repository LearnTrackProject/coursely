import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    final newState = isDark ? ThemeMode.light : ThemeMode.dark;
    emit(newState);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark', !isDark);
  }
}
