import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
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
        title: Text(AppLocalizations.of(context)!.settings_reset_confirm_title),
        content: Text(AppLocalizations.of(context)!.settings_reset_confirm_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.settings_reset_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.settings_reset_confirm, style: TextStyle(color: Colors.red)),
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
        debugPrint('Failed to reset database: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.settings_export_database),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: _exportDatabase,
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.settings_reset_database),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => _resetDatabase(context),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.settings_opensource_licenses),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, 'opensource'),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.settings_about),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, 'about'),
        )
      ],
    ));
  }
}
