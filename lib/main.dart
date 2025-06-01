// main.dart
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(YawnOnApp());
}

class YawnOnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yawn&On',
      theme: ThemeData(
        primaryColor: Color(0xFF1E3A8A), // Dark blue
        scaffoldBackgroundColor: Color(0xFFFAFAFA), // Soft white
        fontFamily: 'Inter',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}