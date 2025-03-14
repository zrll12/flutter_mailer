import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings_about),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const FlutterLogo(size: 100),
              const SizedBox(height: 20),
              const Text('Flutter Mailer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('${AppLocalizations.of(context)!.settings_version} 1.0.0+3'),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.settings_description),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                    text: "https://github.com/zrll12/flutter_mailer",
                    style:
                        const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString(
                            "https://github.com/zrll12/flutter_mailer");
                      }),
              ),
              const SizedBox(height: 10),
              const Text('© 2025 zrll')
            ],
          ),
        ));
  }
}
