import 'package:notesy/res/res.dart';

final lightTheme = ThemeData(
  useMaterial3: false,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.grey[100],
  canvasColor: Colors.white,
  dividerColor: Colors.black,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.grey[100],
    iconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardColor: Colors.white,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
  ),
  hintColor: Colors.black.withOpacity(0.3),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 14.sp,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 16.sp,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 18.sp,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blue.withOpacity(0.4),
    cursorColor: Colors.black,
    selectionHandleColor: Colors.blue,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 14.sp,
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: false,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.black,
  canvasColor: Colors.grey[850],
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardColor: Colors.grey[900],
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
  hintColor: Colors.white.withOpacity(0.3),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 18.sp,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blueAccent.withOpacity(0.4),
    cursorColor: Colors.white,
    selectionHandleColor: Colors.blueAccent,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.grey[850],
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
    ),
  ),
);
