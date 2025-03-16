import 'package:flutter/material.dart';
import 'package:wish_list_client/models/wish_model.dart';

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
          // TODO: Navigate to wish details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (wish.imageUrl != null)
              Image.network(
                wish.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
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
