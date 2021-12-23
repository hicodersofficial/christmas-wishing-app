import 'package:christmas/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  return runApp(const Christmas());
}

class Christmas extends StatelessWidget {
  const Christmas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xFF000000),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'poppins',
        scaffoldBackgroundColor: const Color(0xFF000000),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFFF30B45),
            ),
          ),
        ),
      ),
      home: const SafeArea(
        child: Home(),
      ),
    );
  }
}
