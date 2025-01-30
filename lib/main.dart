import 'package:flutter/material.dart';
import 'package:flutter_mailer/screen/home_screen.dart';

void main() {
  runApp(const FlutterMailer());
}

class FlutterMailer extends StatelessWidget {
  const FlutterMailer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}