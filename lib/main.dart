import 'dart:developer';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:findra/screens/chat_screen.dart';
import 'package:findra/themes/color_schemes.dart';
import 'package:findra/themes/text_themes.dart';
import 'package:findra/utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppPreferences appPreferences = AppPreferences();
  await appPreferences.loadPreferences();
  runApp(Findra(appPreferences: appPreferences));
}

class Findra extends StatefulWidget {
  final AppPreferences appPreferences;
  const Findra({super.key, required this.appPreferences});

  @override
  State<Findra> createState() => _FindraState();
}

class _FindraState extends State<Findra> {
  ThemeMode themeMode = ThemeMode.system;
  String selectedModel = "gemini";
  ColorScheme lightColorScheme = ColorSchemes.lightScheme();
  ColorScheme darkColorScheme = ColorSchemes.darkScheme();

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setPreferredOrientations();
  }

  Future<void> _initializeApp() async {
    setState(() {
      themeMode = widget.appPreferences.themeMode;
      selectedModel = widget.appPreferences.selectedModel;
    });
  }

  void _setPreferredOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _setThemeMode(BuildContext context, String value) {
    setState(() {
      themeMode = value == "dark" ? ThemeMode.dark : ThemeMode.light;
    });
    widget.appPreferences.savePreferences(themeMode, selectedModel);
    _setSystemStyle();
  }

  void _setSystemStyle() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: themeMode == ThemeMode.dark
          ? lightColorScheme.onSurface
          : darkColorScheme.onSurface,
    ));
  }

  void _changeDefaultModel(String value) {
    setState(() {
      selectedModel = value;
    });
    log("Setting model to $value");
    widget.appPreferences.savePreferences(themeMode, selectedModel);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Poppins', "ABeeZee");
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        lightColorScheme = lightDynamic?? ColorSchemes.lightScheme();
        darkColorScheme = darkDynamic?? ColorSchemes.darkScheme();
        return MaterialApp(
          title: 'Findra',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic ?? ColorSchemes.lightScheme(),
            textTheme: textTheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? ColorSchemes.darkScheme(),
            textTheme: textTheme,
          ),
          themeMode: themeMode,
          home: ChatScreen(
            selectedModel: selectedModel,
            setThemeMode: _setThemeMode,
            changeDefaultModel: _changeDefaultModel,
          ),
        );
      },
    );
  }
}