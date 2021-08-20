import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:strapen_app/app/shared/components/padding/padding_button.dart';
import 'package:strapen_app/app/shared/components/text_input/outline_input_default.dart';
import 'package:strapen_app/app/shared/components/text_input/outline_input_error.dart';

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
        hintColor: Colors.grey[400],
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: AppColors.primary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline2: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w600, fontFamily: 'Lexend'),
          headline3: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          headline4: TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.w600, fontFamily: 'Lexend'),
          headline5: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          bodyText1: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Lexend'),
          bodyText2: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
          button: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Lexend'),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            elevation: 4,
            padding: const PaddingButton(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: AppColors.primary,
            padding: const PaddingButton(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(
              color: AppColors.primary,
              width: 1.2,
              style: BorderStyle.solid,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: AppColors.primary,
          ),
        ),
        dividerTheme: DividerThemeData(space: 0),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          enabledBorder: OutlineInputDefault(),
          focusedBorder: OutlineInputDefault(),
          errorBorder: OutlineInputError(),
          focusedErrorBorder: OutlineInputError(),
          errorStyle: TextStyle(color: AppColors.error),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.background,
          contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        radioTheme: RadioThemeData(
          splashRadius: 16,
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    ).modular();
  }
}

abstract class AppColors {
  static Color get primary => Color(0xFF00CC99);

  static Color get secondary => Color(0xFFFBFCFF);

  static Color get background => Color(0xFF2A2B2E);

  static Color get primaryDark => Color(0xFF00A676);

  static Color get error => Color(0xFFDD403A);

  static Color get opaci => Color(0x19D4D4D4);

  static List<Color> get gradiente => [Color(0xFF00CC99), Color(0xFF00A676)];
}
