import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/user_avatar.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/screens/profile_screen.dart';
import 'dart:convert';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showAvatar;

  CustomAppBar({
    required this.title,
    this.backgroundColor,
    this.actions,
    this.showBackButton = true,
    this.showAvatar = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    final List<Widget> appBarActions = actions ?? [];

    if (showAvatar && user != null) {
      appBarActions.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ),
      );
    }

    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      leading:
          showBackButton
              ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
              : null,
      actions: appBarActions,
    );
  }
}
