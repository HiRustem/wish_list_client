import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wish_list_client/models/wish_model.dart';
import 'package:wish_list_client/screens/wish_detail_screen.dart';

class WishCard extends StatelessWidget {
  final WishModel wish;

  const WishCard({required this.wish});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WishDetailScreen(wish: wish),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (wish.imageUrl != null && wish.imageUrl!.isNotEmpty)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(wish.imageUrl!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wish.title, style: theme.textTheme.titleMedium),
                  if (wish.description != null)
                    Text(wish.description!, style: theme.textTheme.bodyMedium),
                  if (wish.type == WishType.PRODUCT && wish.link != null)
                    TextButton(
                      onPressed: () {
                        // TODO: Open product link
                      },
                      child: Text('Open Product Link'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
