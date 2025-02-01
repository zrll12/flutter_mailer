import 'package:sqflite/sqflite.dart';

class Email {
  final int? id;
  final String text;
  final String html;
  final String subject;
  final String sender;
  final String recipients;
  final DateTime date;
  final String mailbox;
  final int profileId;
  final int sequenceId;

  Email({
    required this.id,
    required this.sequenceId,
    required this.mailbox,
    required this.profileId,
    required this.text,
    required this.html,
    required this.subject,
    required this.sender,
    required this.recipients,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sequenceId': sequenceId,
      'profileId': profileId,
      'subject': subject,
      'sender': sender,
      'recipients': recipients,
      'date': date.toIso8601String(),
      'text': text,
      'html': html,
      'mailbox': mailbox,
    };
  }

  static Email fromMap(Map<String, dynamic> map) {
    return Email(
      id: map['id'],
      sequenceId: map['sequenceId'],
      profileId: map['profileId'],
      subject: map['subject'],
      sender: map['sender'],
      recipients: map['recipients'],
      date: DateTime.parse(map['date']),
      text: map['text'],
      html: map['html'],
      mailbox: map['mailbox'],
    );
  }

  void insert(Database db) async {
    // If the email already exists, skip
    final List<Map<String, dynamic>> emails = await db.query(
      'email',
      where: 'sequenceId = ? AND mailbox = ? AND profileId = ? AND date = ?',
      whereArgs: [sequenceId, mailbox, profileId, date.toIso8601String()],
    );
    if (emails.isNotEmpty) {
      return;
    }

    await db.insert('email', toMap());
  }

  static Future<List<Email>> getEmails(
      Database db, {
      int? profileId,
      String? mailbox,
    }) async {
      String? whereClause;
      List<dynamic> whereArgs = [];
  
      if (profileId != null && mailbox != null) {
        whereClause = 'profileId = ? AND mailbox = ?';
        whereArgs = [profileId, mailbox];
      } else if (profileId != null) {
        whereClause = 'profileId = ?';
        whereArgs = [profileId];
      } else if (mailbox != null) {
        whereClause = 'mailbox = ?';
        whereArgs = [mailbox];
      }
  
      final List<Map<String, dynamic>> emails = await db.query(
        'email',
        where: whereClause,
        whereArgs: whereArgs,
      );
      return emails.map((e) => Email.fromMap(e)).toList();
    }
}