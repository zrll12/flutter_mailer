// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get tab_home {
    return Intl.message('Home', name: 'tab_home', desc: '', args: []);
  }

  /// `Profile`
  String get tab_profile {
    return Intl.message('Profile', name: 'tab_profile', desc: '', args: []);
  }

  /// `Settings`
  String get tab_settings {
    return Intl.message('Settings', name: 'tab_settings', desc: '', args: []);
  }

  /// `All Accounts`
  String get home_all_accounts {
    return Intl.message(
      'All Accounts',
      name: 'home_all_accounts',
      desc: '',
      args: [],
    );
  }

  /// `All Folders`
  String get home_all_folders {
    return Intl.message(
      'All Folders',
      name: 'home_all_folders',
      desc: '',
      args: [],
    );
  }

  /// `Load More`
  String get home_load_more {
    return Intl.message(
      'Load More',
      name: 'home_load_more',
      desc: '',
      args: [],
    );
  }

  /// `Add Profile`
  String get profile_add_profile {
    return Intl.message(
      'Add Profile',
      name: 'profile_add_profile',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get profile_email {
    return Intl.message('Email', name: 'profile_email', desc: '', args: []);
  }

  /// `Password`
  String get profile_password {
    return Intl.message(
      'Password',
      name: 'profile_password',
      desc: '',
      args: [],
    );
  }

  /// `SMTP Server`
  String get profile_smtp_server {
    return Intl.message(
      'SMTP Server',
      name: 'profile_smtp_server',
      desc: '',
      args: [],
    );
  }

  /// `IMAP Server`
  String get profile_imap_server {
    return Intl.message(
      'IMAP Server',
      name: 'profile_imap_server',
      desc: '',
      args: [],
    );
  }

  /// `Use SSL`
  String get profile_use_ssl {
    return Intl.message('Use SSL', name: 'profile_use_ssl', desc: '', args: []);
  }

  /// `Delete`
  String get profile_delete {
    return Intl.message('Delete', name: 'profile_delete', desc: '', args: []);
  }

  /// `Save`
  String get profile_save {
    return Intl.message('Save', name: 'profile_save', desc: '', args: []);
  }

  /// `Profile Detail`
  String get profile_detail {
    return Intl.message(
      'Profile Detail',
      name: 'profile_detail',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get profile_detail_no_data {
    return Intl.message(
      'No Data',
      name: 'profile_detail_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Delete Profile`
  String get profile_delete_confirm_title {
    return Intl.message(
      'Delete Profile',
      name: 'profile_delete_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this profile?`
  String get profile_delete_confirm_message {
    return Intl.message(
      'Are you sure you want to delete this profile?',
      name: 'profile_delete_confirm_message',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get profile_delete_confirm {
    return Intl.message(
      'Delete',
      name: 'profile_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get profile_delete_cancel {
    return Intl.message(
      'Cancel',
      name: 'profile_delete_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Export Database`
  String get settings_export_database {
    return Intl.message(
      'Export Database',
      name: 'settings_export_database',
      desc: '',
      args: [],
    );
  }

  /// `Reset Database`
  String get settings_reset_database {
    return Intl.message(
      'Reset Database',
      name: 'settings_reset_database',
      desc: '',
      args: [],
    );
  }

  /// `Open Source Licenses`
  String get settings_opensource_licenses {
    return Intl.message(
      'Open Source Licenses',
      name: 'settings_opensource_licenses',
      desc: '',
      args: [],
    );
  }

  /// `Licenses Contents`
  String get settings_opensource_licenses_content {
    return Intl.message(
      'Licenses Contents',
      name: 'settings_opensource_licenses_content',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get settings_about {
    return Intl.message('About', name: 'settings_about', desc: '', args: []);
  }

  /// `Version`
  String get settings_version {
    return Intl.message(
      'Version',
      name: 'settings_version',
      desc: '',
      args: [],
    );
  }

  /// `A simple mail client app built with Flutter.`
  String get settings_description {
    return Intl.message(
      'A simple mail client app built with Flutter.',
      name: 'settings_description',
      desc: '',
      args: [],
    );
  }

  /// `Reset Database`
  String get settings_reset_confirm_title {
    return Intl.message(
      'Reset Database',
      name: 'settings_reset_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset the database? This action cannot be undone.`
  String get settings_reset_confirm_message {
    return Intl.message(
      'Are you sure you want to reset the database? This action cannot be undone.',
      name: 'settings_reset_confirm_message',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get settings_reset_confirm {
    return Intl.message(
      'Reset',
      name: 'settings_reset_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get settings_reset_cancel {
    return Intl.message(
      'Cancel',
      name: 'settings_reset_cancel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
