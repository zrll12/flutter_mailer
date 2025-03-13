import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/page/opensource.dart';

import 'page/email/email_details.dart';
import 'page/profile/add_profile.dart';
import 'page/profile/profile_details.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(const FlutterMailer());
}

class FlutterMailer extends StatelessWidget {
  const FlutterMailer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: "Flutter Mailer",
          theme: ThemeData(
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
          ),
          home: const HomeScreen(),
          routes: {
            'home': (context) => const HomeScreen(),
            'add_profile': (context) => const AddProfilePage(),
            'profile_details': (context) => ProfileDetails(),
            'email_details': (context) => EmailDetails(),
            'opensource': (context) => const OpenSourcePage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
