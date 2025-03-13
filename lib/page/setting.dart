import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> _exportDatabase() async {
    try {
      final dbPath = path.join(await getDatabasesPath(), 'flutter_mailer.db');
      final file = File(dbPath);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(dbPath)],
            subject: 'Flutter Mailer Database');
      }
    } catch (e) {
      debugPrint('Error exporting database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
      itemCount: 2,
      separatorBuilder: (context, index) =>
          const Divider(thickness: 0.8, indent: 20, endIndent: 30),
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: const Text('Export Database'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: _exportDatabase,
          );
        } else {
          return ListTile(
            title: const Text('开源软件'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.pushNamed(context, 'opensource'),
          );
        }
      },
    ));
  }
}
