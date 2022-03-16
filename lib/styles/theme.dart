import 'package:flutter/material.dart';
import 'colors.dart';
import 'styling.dart';

class CustomTheme {
  // static bool _isDarkTheme = true;

  // ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  // static TextStyle get sideBarTextColor => _isDarkTheme
  //     ? TextStyle(color: Colors.white)
  //     : TextStyle(color: Colors.green);

  // void toggleTheme() {
  //   _isDarkTheme = !_isDarkTheme;
  //   notifyListeners();
  // }

  static ThemeData get defaultTheme {
    return ThemeData(
      canvasColor: CustomColors.lightModeScaffoldColour,
      scaffoldBackgroundColor: CustomColors.lightModeScaffoldColour,
      appBarTheme: AppBarTheme(
        color: CustomColors.green,
        foregroundColor: CustomColors.appBarTextColor,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titleTextStyle: popupDialogTitleTextStyle,
        contentTextStyle: popupDialogTextStyle,
        alignment: Alignment.center,
      ),
      listTileTheme: ListTileThemeData(textColor: CustomColors.green),
      primarySwatch: CustomColors.lightGreen,
      backgroundColor: CustomColors.green,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      canvasColor: CustomColors.darkModeScaffoldColour,
      scaffoldBackgroundColor: CustomColors.darkModeScaffoldColour,
      appBarTheme: AppBarTheme(color: CustomColors.darkModeScaffoldColour),
      primarySwatch: Colors.grey,
      colorScheme: ColorScheme.dark(
        secondary: CustomColors.darkModeScaffoldColour,
      ),
      backgroundColor: CustomColors.darkModeScaffoldColour,
      textTheme: ThemeData.dark().textTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.darkModeScaffoldColour,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}