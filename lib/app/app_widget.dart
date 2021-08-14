import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strapen',
      debugShowCheckedModeBanner: false,
      initialRoute: Modular.initialRoute,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primaryColorDark: AppColors.primaryDark,
        primaryColorLight: AppColors.secondary,
        scaffoldBackgroundColor: AppColors.background,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline2: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline3: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline4: TextStyle(color: AppColors.secondary, fontSize: 50, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline5: TextStyle(color: AppColors.secondary, fontSize: 50, fontWeight: FontWeight.w600, fontFamily: 'Lexend'),
          bodyText1: TextStyle(color: Colors.grey[700], fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
          bodyText2: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),
    ).modular();
  }
}

abstract class AppColors {
  static Color get primary => Color(0xFF00CC99);
  static Color get secondary => Color(0xFFFBFCFF);
  static Color get background => Color(0xFF2A2B2E);
  static Color get primaryDark => Color(0xFF00A676);
  static Color get error => Color(0xFFDD403A);
  static List<Color> get gradiente => [Color(0xFF00CC99), Color(0xFF00A676)];
}