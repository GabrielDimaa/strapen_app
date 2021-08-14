import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  Color get primary => Color(0xFF00CC99);
  Color get secondary => Color(0xFFFBFCFF);
  Color get background => Color(0xFF2A2B2E);
  Color get primaryDark => Color(0xFF00A676);
  Color get error => Color(0xFFDD403A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strapen',
      debugShowCheckedModeBanner: false,
      initialRoute: Modular.initialRoute,
      theme: ThemeData(
        primaryColor: primary,
        primaryColorDark: primaryDark,
        primaryColorLight: secondary,
        scaffoldBackgroundColor: background,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primary,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline2: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline3: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline4: TextStyle(color: secondary, fontSize: 56, fontWeight: FontWeight.w800, fontFamily: 'Lexend'),
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
