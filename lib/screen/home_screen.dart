
import 'package:flutter/material.dart';
import 'package:flutter_mailer/page/home.dart';
import 'package:flutter_mailer/page/profile.dart';
import 'package:flutter_mailer/page/setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<NavigationDestination> bottomNavigationBarItems = [
    NavigationDestination(
      label: 'Home',
      icon: Icon(Icons.email_outlined),
    ),
    NavigationDestination(
      label: 'Profile',
      icon: Icon(Icons.person_outline),
    ),
    NavigationDestination(
      label: 'Settings',
      icon: Icon(Icons.settings_outlined),
    ),
  ];

  int _bottomIndex = 0;

  void _bottomIndexChanged(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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