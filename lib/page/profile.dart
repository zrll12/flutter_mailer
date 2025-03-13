import 'package:flutter/material.dart';
import 'package:flutter_mailer/service/profile_service.dart';
import 'package:flutter_mailer/model/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  List<Profile> _profiles = [];
  bool _isLoading = false;

  void _addProfile(context) {
    Navigator.pushNamed(context, 'add_profile').then((value) {
      if (value != null) {
        _profileService.addProfile(value as Profile).then((_) => _loadProfiles());
      }
    });
  }

  Future<void> _loadProfiles() async {
    setState(() => _isLoading = true);
    try {
      final profiles = await _profileService.getProfiles();
      if (mounted) {
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _profiles.length,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 0.8, indent: 20, endIndent: 30),
              itemBuilder: (context, index) => ListTile(
                title: Text(_profiles[index].email),
                subtitle: Text(_profiles[index].imapServer),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.pushNamed(
                  context,
                  'profile_details',
                  arguments: _profiles[index].toJson(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProfile(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
