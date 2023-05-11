import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/screens/Welcome/welcome_screen.dart';
import 'package:budget_app/screens/bottomnavigation.dart';
import 'package:budget_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'common/color_schemes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Budget App',
        theme: ThemeData(
            colorScheme: lightColorScheme,
            fontFamily: 'Inter',
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Inter'),
            useMaterial3: true),
        home:const WelcomeScreen());
  }
}
