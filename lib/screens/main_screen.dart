import 'package:flutter/material.dart';
import 'package:wish_list_client/components/bottom_navigation.dart';
import 'package:wish_list_client/screens/home_screen.dart';
import 'package:wish_list_client/screens/profile_screen.dart';
import 'package:wish_list_client/screens/search_screen.dart';
import 'package:wish_list_client/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
