import 'package:flutter/material.dart';
import 'package:wish_list_client/components/wish_card.dart';
import 'package:wish_list_client/models/wish_model.dart';

class Wishlist extends StatelessWidget {
  final List<WishModel> wishes;

  const Wishlist({required this.wishes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: wishes.length,
      itemBuilder: (context, index) {
        return WishCard(wish: wishes[index]);
      },
    );
  }
}
