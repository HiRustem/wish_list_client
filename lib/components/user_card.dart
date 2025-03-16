import 'package:flutter/material.dart';
import 'package:wish_list_client/components/user_avatar.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/screens/profile_screen.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final bool isFollowed;
  final VoidCallback onFollowToggle;
  final bool isSwitchingSubscription;

  const UserCard({
    required this.user,
    required this.isFollowed,
    required this.onFollowToggle,
    this.isSwitchingSubscription = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(avatar: user.avatar),
      title: Text(user.nickname ?? 'Unknown User'),
      trailing:
          isSwitchingSubscription
              ? CircularProgressIndicator()
              : IconButton(
                icon: Icon(isFollowed ? Icons.person_remove : Icons.person_add),
                onPressed: onFollowToggle,
              ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: user.id),
          ),
        );
      },
    );
  }
}
