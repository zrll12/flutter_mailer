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

  Email({
    required this.id,
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

  Future<void> insert(Database db) async {
    // If the email already exists, skip
    final List<Map<String, dynamic>> emails = await db.query(
      'email',
      where: 'subject = ? AND mailbox = ? AND profileId = ? AND date = ?',
      whereArgs: [subject, mailbox, profileId, date.toIso8601String()],
    );
    if (emails.isNotEmpty) {
      return;
    }

    await db.insert('email', toMap());
  }

  static Future<List<Email>> getEmails(
    Database db, {
    List<int>? profileIds,
    List<String>? mailboxes,
    int limit = 50,
    int offset = 0,
  }) async {
    String? whereClause;
    List<dynamic> whereArgs = [];

    if (profileIds != null &&
        profileIds.isNotEmpty &&
        mailboxes != null &&
        mailboxes.isNotEmpty) {
      whereClause =
          'profileId IN (${List.filled(profileIds.length, '?').join(',')}) AND mailbox IN (${List.filled(mailboxes.length, '?').join(',')})';
      whereArgs = [...profileIds, ...mailboxes];
    } else if (profileIds != null && profileIds.isNotEmpty) {
      whereClause =
          'profileId IN (${List.filled(profileIds.length, '?').join(',')})';
      whereArgs = profileIds;
    } else if (mailboxes != null && mailboxes.isNotEmpty) {
      whereClause =
          'mailbox IN (${List.filled(mailboxes.length, '?').join(',')})';
      whereArgs = mailboxes;
    }

    try {
      final List<Map<String, dynamic>> emails = await db.query(
        'email',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'date DESC',
        limit: limit,
        offset: offset,
      );
      return emails.map((e) => Email.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching emails: $e');
      return [];
    }
  }

  static Future<List<String>> getMailboxes(Database db,
      {int? profileId}) async {
    String? whereClause;
    List<dynamic> whereArgs = [];

    if (profileId != null) {
      whereClause = 'profileId = ?';
      whereArgs = [profileId];
    }

    final List<Map<String, dynamic>> results = await db.query(
      'email',
      distinct: true,
      columns: ['mailbox'],
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'mailbox ASC',
    );

    return results.map((e) => e['mailbox'] as String).toList();
  }
}
