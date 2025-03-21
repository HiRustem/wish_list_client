import 'dart:convert'; // Для base64Decode
import 'package:flutter/material.dart';
import 'package:wish_list_client/models/wish_model.dart';

class WishDetailScreen extends StatelessWidget {
  final WishModel wish;

  const WishDetailScreen({required this.wish});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(wish.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 16),
            if (wish.description != null)
              Text(wish.description!, style: theme.textTheme.bodyMedium),
            if (wish.type == WishType.PRODUCT && wish.link != null)
              TextButton(
                onPressed: () {
                  // Открыть ссылку на товар
                },
                child: Text('Open Product Link'),
              ),
          ],
        ),
      ),
    );
  }
}
