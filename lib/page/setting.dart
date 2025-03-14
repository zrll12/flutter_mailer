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

  Future<void> _resetDatabase(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reset'),
        content: const Text('Are you sure you want to reset the database? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        final dbPath = path.join(await getDatabasesPath(), 'flutter_mailer.db');
        await deleteDatabase(dbPath);
        exit(0);
      } catch (e) {
        debugPrint('重置数据库失败: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        ListTile(
          title: const Text('Export Database'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: _exportDatabase,
        ),
        ListTile(
          title: const Text('Reset Database'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => _resetDatabase(context),
        ),
        ListTile(
          title: const Text('Opensource Licenses'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, 'opensource'),
        ),
        ListTile(
          title: const Text("About"),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, 'about'),
        )
      ],
    ));
  }
}
