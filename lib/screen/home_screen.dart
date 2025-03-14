import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mailer/page/home.dart';
import 'package:flutter_mailer/page/profile.dart';
import 'package:flutter_mailer/page/setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomIndex = 0;

  void _bottomIndexChanged(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<NavigationDestination> bottomNavigationBarItems = [
      NavigationDestination(
        label: AppLocalizations.of(context)!.tab_home,
        icon: const Icon(Icons.email_outlined),
      ),
      NavigationDestination(
        label: AppLocalizations.of(context)!.tab_profile,
        icon: const Icon(Icons.person_outline),
      ),
      NavigationDestination(
        label: AppLocalizations.of(context)!.tab_settings,
        icon: const Icon(Icons.settings_outlined),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Mailer'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: bottomNavigationBarItems,
        selectedIndex: _bottomIndex,
        onDestinationSelected: _bottomIndexChanged,
      ),
      body: IndexedStack(
        index: _bottomIndex,
        children: [
          HomePage(),
          ProfilePage(),
          const SettingPage(),
        ],
      ),
    );
  }
}
