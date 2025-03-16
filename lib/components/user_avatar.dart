import 'package:flutter/material.dart';
import 'dart:convert';

class UserAvatar extends StatelessWidget {
  final String? avatar;
  final double radius;
  final VoidCallback? onTap;

  UserAvatar({this.avatar, this.radius = 16, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage:
            avatar != null ? MemoryImage(base64Decode(avatar!)) : null,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child:
            avatar == null
                ? Icon(
                  Icons.person,
                  size: radius,
                  color: Theme.of(context).colorScheme.onSecondary,
                )
                : null,
      ),
    );
  }
}
