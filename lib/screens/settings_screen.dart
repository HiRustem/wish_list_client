import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Change Username'),
            onTap: () {
              // Логика изменения никнейма
            },
          ),
          ListTile(
            title: Text('Change Avatar'),
            onTap: () {
              // Логика изменения аватара
            },
          ),
          ListTile(
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await userProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
