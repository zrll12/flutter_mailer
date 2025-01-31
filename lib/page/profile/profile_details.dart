import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';

import '../../model/profile.dart';

class ProfileDetails extends StatefulWidget {
  ProfileDetails({super.key});

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

  // 添加控制器作为成员变量
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
    );

    databaseHelper.db
        .then((db) => profile.update(db, oldEmail))
        .then((value) => Navigator.pop(context, true));
  }

  void deleteProfile(String email, context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Profile'),
              content: Text('Are you sure you want to delete this profile?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Yes'),
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
            title: Text('Profile Detail'),
          ),
          body: Center(
            child: Text('No data'),
          ));
    }

    // 删除这里重复设置值的代码
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Detail'),
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
                    decoration: const InputDecoration(
                      labelText: 'Email',
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
                      labelText: 'SMTP Server',
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
                      labelText: 'IMAP Server',
                    ),
                    onChanged: (value) {
                      setState(() {
                        imapServer = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      const Text('Use SSL'),
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
                          child: Text('Delete')),
                      Spacer(),
                      FilledButton(
                          onPressed: updateProfile, child: Text('Save')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
