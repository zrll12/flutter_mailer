import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mailer/database.dart';

import '../../model/profile.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String email = '';
  String oldEmail = '';
  String imapServer = '';
  String smtpServer = '';
  String password = '';
  bool useSSL = false;
  int id = 0;

  late TextEditingController emailController;
  late TextEditingController smtpController;
  late TextEditingController imapController;

  @override
  void dispose() {
    emailController.dispose();
    smtpController.dispose();
    imapController.dispose();
    super.dispose();
  }

  void updateProfile() {
    Profile profile = Profile(
      email: email,
      password: password,
      smtpServer: smtpServer,
      imapServer: imapServer,
      useSSL: useSSL,
      id: id,
    );

    databaseHelper.db
        .then((db) => profile.update(db, oldEmail))
        .then((value) => Navigator.pop(context, true));
  }

  void deleteProfile(String email, context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.profile_delete_confirm_title),
              content: Text(AppLocalizations.of(context)!.profile_delete_confirm_message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context)!.profile_delete_cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context)!.profile_delete_confirm),
                ),
              ],
            )).then((value) {
      if (value == true) {
        databaseHelper.db
            .then((db) => Profile.delete(db, email))
            .then((value) => Navigator.pop(context, true));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    smtpController = TextEditingController();
    imapController = TextEditingController();

    // 延迟初始化，等待 build 后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      id = args?['id'] ?? 0;

      if (args != null) {
        setState(() {
          oldEmail = args['email'] ?? '';
          email = args['email'] ?? '';
          smtpServer = args['smtpServer'] ?? '';
          imapServer = args['imapServer'] ?? '';
          useSSL = args['useSSL'] == 1;

          emailController.text = email;
          smtpController.text = smtpServer;
          imapController.text = imapServer;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.profile_detail),
          ),
          body: Center(
            child: Text(AppLocalizations.of(context)!.profile_detail_no_data),
          ));
    }

    // 删除这里重复设置值的代码
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile_detail),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
          child: Container(
            child: Center(
              child: Column(
                spacing: 15,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.profile_email,
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  TextField(
                    controller: smtpController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.profile_smtp_server,
                    ),
                    onChanged: (value) {
                      setState(() {
                        smtpServer = value;
                      });
                    },
                  ),
                  TextField(
                    controller: imapController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.profile_imap_server,
                    ),
                    onChanged: (value) {
                      setState(() {
                        imapServer = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.profile_password,
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.profile_use_ssl),
                      Spacer(),
                      Switch(
                        value: useSSL,
                        onChanged: (value) {
                          setState(() {
                            useSSL = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                          onPressed: () => deleteProfile(oldEmail, context),
                          child: Text(AppLocalizations.of(context)!.profile_delete)),
                      Spacer(),
                      FilledButton(
                          onPressed: updateProfile, child: Text(AppLocalizations.of(context)!.profile_save)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
