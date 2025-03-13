import 'package:flutter/material.dart';
import 'package:flutter_mailer/licenses/Apache2.0.dart';
import 'package:flutter_mailer/licenses/BSD2Clause.dart';
import 'package:flutter_mailer/licenses/BSD3Clause.dart';
import 'package:flutter_mailer/licenses/MIT.dart';
import 'package:flutter_mailer/licenses/MPL2.0.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenSourcePage extends StatelessWidget {
  const OpenSourcePage({super.key});

  Future<void> _launchPackageUrl(String package) async {
    final url = Uri.parse('https://pub.dev/packages/$package');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, List<String>> lincences = {
      'MIT': [
        "cupertino_icons",
        "uuid",
        "fluttertoast"
      ],
      'Apache 2.0': [
        "dynamic_color"
      ],
      'BSD 2-Clause': [
        "sqflite"
      ],
      'BSD 3-Clause': [
        "flutter_secure_storage",
        "encrypt",
        "path",
        "date_format",
        "webview_flutter",
        "url_launcher",
        "share_plus",
        "flutter"
      ],
      'MPL 2.0': [
        "enough_mail"
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('开源软件'),
      ),
      body: ListView(
        children: lincences.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: [
              ...entry.value.map((package) => ListTile(
                    title: Text(package),
                    dense: true,
                    onTap: () => _launchPackageUrl(package),
                  )),
              ListTile(
                title: const Text('查看协议内容'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LicensePage(
                        title: entry.key,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class LicensePage extends StatelessWidget {
  final String title;

  const LicensePage({super.key, required this.title});

  String _getLicenseText() {
    switch (title) {
      case 'MIT':
        return mit;
      case 'Apache 2.0':
        return apache2_0;
      case 'BSD 2-Clause':
        return bsd2Clause;
      case 'BSD 3-Clause':
        return bsd3Clause;
      case 'MPL 2.0':
        return mpl2_0;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(_getLicenseText()),
      ),
    );
  }
}