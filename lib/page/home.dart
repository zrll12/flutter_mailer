import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mailer/model/email.dart';
import 'package:flutter_mailer/model/profile.dart';
import 'package:flutter_mailer/service/email_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EmailService _emailService = EmailService();
  List<Profile> _profiles = [];
  List<Email> _emails = [];
  List<String> _selectedFolders = [];
  List<int> _selectedProfiles = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  static const int _pageSize = 50;
  List<String> _availableFolders = [];

  Future<void> _loadEmails() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final emails = await _emailService.loadEmails(
        profileIds: _selectedProfiles.isEmpty ? null : _selectedProfiles,
        mailboxes: _selectedFolders.isEmpty ? null : _selectedFolders,
        limit: _pageSize,
        offset: _currentPage * _pageSize,
      );
      final folders = await _emailService.getMailboxes(
        profileId: _selectedProfiles.isEmpty ? null : _selectedProfiles.first,
      );

      if (mounted) {
        setState(() {
          _emails = _currentPage == 0 ? emails : [..._emails, ...emails];
          _availableFolders = folders;
          _hasMore = emails.length == _pageSize;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resetAndReload() {
    setState(() {
      _currentPage = 0;
      _hasMore = true;
      _emails.clear();
    });
    _loadEmails();
  }

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _selectedProfiles.isEmpty ? null : _selectedProfiles.first,
              items: [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text(AppLocalizations.of(context)!.home_all_accounts),
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
                setState(
                    () => _selectedProfiles = value != null ? [value] : []);
                _resetAndReload();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedFolders.isEmpty ? null : _selectedFolders.first,
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(AppLocalizations.of(context)!.home_all_folders),
                ),
                ..._availableFolders.map((folder) => DropdownMenuItem<String>(
                      value: folder,
                      child: Text(folder),
                    )),
              ],
              onChanged: (value) {
                setState(() => _selectedFolders = value != null ? [value] : []);
                _resetAndReload();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailList() {
    return ListView.separated(
      itemCount: _emails.length + (_hasMore ? 1 : 0),
      separatorBuilder: (context, index) =>
          const Divider(thickness: 0.8, indent: 20, endIndent: 30),
      itemBuilder: (context, index) {
        if (index == _emails.length) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: TextButton(
              onPressed: () {
                setState(() => _currentPage++);
                _loadEmails();
              },
              child: Text(AppLocalizations.of(context)!.home_load_more),
            ),
          );
        }

        final email = _emails[index];
        return ListTile(
          title: Text(email.subject),
          subtitle: Text(
            '${formatDate(email.date, [
                  yyyy,
                  '-',
                  mm,
                  '-',
                  dd,
                  ' ',
                  HH,
                  ':',
                  mm
                ])} · ${email.mailbox}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(
            context,
            'email_details',
            arguments: email.toMap(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _buildFilterRow(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _emailService.syncEmails(context);
                  _resetAndReload();
                },
                child: _buildEmailList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
