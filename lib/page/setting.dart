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
        title: const Text('确认重置'),
        content: const Text('将删除所有数据库记录，该操作不可恢复！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认重置', style: TextStyle(color: Colors.red)),
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
        body: ListView.separated(
      itemCount: 3,
      separatorBuilder: (context, index) =>
          const Divider(thickness: 0.8, indent: 20, endIndent: 30),
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: const Text('Export Database'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: _exportDatabase,
          );
        } else if (index == 1) {
          return ListTile(
            title: const Text('重置数据库'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => _resetDatabase(context),
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
