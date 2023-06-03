import 'package:flutter/material.dart';
import 'package:weather_app/Screens/homescreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    theme: ThemeData(
      primaryColor: Colors.white,
    ),
  ));
}
