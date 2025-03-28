import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ne_yiyoz/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xff7b0000),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'Anton',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Anton',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      home: SplashScreen(),
    );
  }
}

