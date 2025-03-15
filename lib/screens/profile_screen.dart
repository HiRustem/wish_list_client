import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/custom_app_bar.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showAvatar: false,
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
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
      body: Column(children: [Text('Users Profile')]),
    );
  }
}
