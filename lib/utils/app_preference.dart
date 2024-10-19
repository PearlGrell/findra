import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  ThemeMode themeMode = ThemeMode.system;
  String selectedModel = "gemini";

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    themeMode = theme == 'light'
        ? ThemeMode.light
        : (theme == 'dark' ? ThemeMode.dark : ThemeMode.system);
    selectedModel = prefs.getString('selectedModel') ?? 'gemini';
  }

  Future<void> savePreferences(
      ThemeMode themeMode, String selectedModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', themeMode == ThemeMode.light ? 'light' : 'dark');
    await prefs.setString('selectedModel', selectedModel);
  }
}
