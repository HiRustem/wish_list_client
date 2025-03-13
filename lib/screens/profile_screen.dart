// screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> _userFuture;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _userFuture = _userService.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final user = snapshot.data!;
          return Column(
            children: [
              Text('Email: ${user.email}'),
              if (user.nickname != null) Text('Nickname: ${user.nickname}'),
              if (user.avatar != null) Image.network(user.avatar!),
            ],
          );
        },
      ),
    );
  }
}
