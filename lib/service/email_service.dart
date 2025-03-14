import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';
import 'package:flutter_mailer/model/email.dart';
import 'package:flutter_mailer/model/profile.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  EmailService._internal();

  factory EmailService() {
    return _instance;
  }

  Future<List<Email>> loadEmails({
    List<int>? profileIds,
    List<String>? mailboxes,
    int limit = 50,
    int offset = 0,
  }) async {
    var db = await databaseHelper.db;
    return Email.getEmails(
      db,
      profileIds: profileIds,
      mailboxes: mailboxes,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<String>> getMailboxes({int? profileId}) async {
    var db = await databaseHelper.db;
    return Email.getMailboxes(db, profileId: profileId);
  }

  Future<void> syncEmails(BuildContext context) async {
    try {
      var db = await databaseHelper.db;
      var profiles = await Profile.getProfiles(db);

      if (profiles.isEmpty) {
        _showMessage(context, '没有配置邮箱账号', Colors.orange);
        return;
      }

      for (var profile in profiles) {
        await _syncProfileEmails(context, profile);
      }
    } catch (e) {
      _showMessage(context, '同步邮件失败：${e.toString()}', Colors.red);
    }
  }

  Future<void> _syncProfileEmails(BuildContext context, Profile profile) async {
    final client = ImapClient(isLogEnabled: false);
    try {
      await _connectAndLogin(client, profile);
      await _fetchAndSaveEmails(client, profile);
      _showMessage(context, '同步${profile.email}成功', Colors.green);
    } catch (e) {
      _showMessage(context, '同步${profile.email}失败：${e.toString()}', Colors.red);
    } finally {
      await client.disconnect();
    }
  }

  Future<void> _connectAndLogin(ImapClient client, Profile profile) async {
    var server = profile.imapServer.split(":");
    if (server.length != 2) {
      server = [profile.imapServer, "993"];
    }
    
    await client.connectToServer(server[0], int.parse(server[1]),
        isSecure: profile.useSSL);
    await client.id(
        clientId: Id(
      name: 'Flutter Mailer',
      version: '1.0',
      vendor: 'Flutter',
    ));
    
    var password = await profile.getPassword();
    if (password == null) {
      throw Exception('无法获取密码');
    }
    
    await client.login(profile.email, password);
  }

  Future<void> _fetchAndSaveEmails(ImapClient client, Profile profile) async {
    var boxes = await client.listMailboxes();
    
    for (var folder in boxes) {
      try {
        await client.selectMailbox(folder);
        var messages = await client.fetchRecentMessages();
        
        for (var message in messages.messages) {
          var email = Email(
            id: null,
            profileId: profile.id,
            sender: message.sender.toString(),
            recipients: message.recipients.toString(),
            subject: message.decodeSubject() ?? 'No Subject',
            text: message.decodeTextPlainPart() ?? '',
            html: message.decodeTextHtmlPart() ?? '',
            date: message.decodeDate() ?? DateTime.now(),
            mailbox: folder.name,
          );
          
          var db = await databaseHelper.db;
          await email.insert(db);
        }
      } catch (e) {
        continue;
      }
    }
  }

  void _showMessage(BuildContext context, String message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}