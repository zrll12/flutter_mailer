import 'package:date_format/date_format.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';
import 'package:flutter_mailer/model/email.dart';

import '../model/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Profile> _profiles = [];
  List<Email> _emails = [];
  List<String> _selectedFolders = [];
  List<int> _selectedProfiles = [];

  Future<void> _freshEmails() async {
    try {
      var db = await databaseHelper.db;
      _profiles = await Profile.getProfiles(db);

      if (_profiles.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('没有配置邮箱账号'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      for (var profile in _profiles) {
        final client = ImapClient(isLogEnabled: false);
        try {
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
            continue;
          }
          await client.login(profile.email, password);

          var boxes = await client.listMailboxes();

          for (var folder in boxes) {
            try {
              await client.selectMailbox(folder);

              var messages = await client.fetchRecentMessages();

              for (var message in messages.messages) {
                Email email = Email(
                  id: null,
                  profileId: profile.id,
                  sender: message.sender.toString(),
                  recipients: message.recipients.toString(),
                  subject: message.decodeSubject() ?? 'No Subject',
                  text: message.decodeTextPlainPart() ?? '',
                  html: message.decodeTextHtmlPart() ?? '',
                  date: message.decodeDate() ?? DateTime.now(),
                  sequenceId: message.sequenceId ?? 0,
                  mailbox: folder.name,
                );
                databaseHelper.db
                    .then((db) => email.insert(db))
                    .then((_) => _loadEmails());
              }
            } catch (e) {
              continue;
            }
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Freshening ${profile.email} succeed'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Freshening ${profile.email} failed: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } finally {
          await client.disconnect();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Freshening ${e.toString()} failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  List<String> _availableFolders = []; // 添加这一行来存储可用的文件夹

  Future<void> _loadEmails() async {
    databaseHelper.db.then((db) async {
      final profiles = await Profile.getProfiles(db);
      final emails = await Email.getEmails(
        db,
        profileIds: _selectedProfiles.isEmpty ? null : _selectedProfiles,
        mailboxes: _selectedFolders.isEmpty ? null : _selectedFolders,
      );
      final folders = await Email.getMailboxes(
        db,
        profileId: _selectedProfiles.isEmpty ? null : _selectedProfiles.first,
      );

      setState(() {
        _profiles = profiles;
        _emails = emails;
        _availableFolders = folders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Select Account'),
                value:
                    _selectedProfiles.isEmpty ? null : _selectedProfiles.first,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('All Accounts'),
                  ),
                  ..._profiles.map((profile) => DropdownMenuItem<int>(
                        value: profile.id,
                        child: Text(
                          profile.email,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedProfiles = value != null ? [value] : [];
                    _loadEmails();
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Folder'),
                value: _selectedFolders.isEmpty ? null : _selectedFolders.first,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Folders'),
                  ),
                  ..._availableFolders.map((folder) => DropdownMenuItem<String>(
                        value: folder,
                        child: Text(folder),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFolders = value != null ? [value] : [];
                    _loadEmails();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      // Existing email list
      for (var i = 0; i < _emails.length; i++) ...[
        ListTile(
          title: Text(_emails[i].subject),
          subtitle: Text(
            '${formatDate(_emails[i].date, [
                  yyyy,
                  '-',
                  mm,
                  '-',
                  dd,
                  ' ',
                  HH,
                  ':',
                  mm
                ])} · ${_emails[i].mailbox}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.pushNamed(context, 'email_details',
                arguments: _emails[i].toMap());
          },
        ),
        if (i < _emails.length - 1) Divider(),
      ]
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _freshEmails();
                },
                child: ListView(
                  children: list,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
