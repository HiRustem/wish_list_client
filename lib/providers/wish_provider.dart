import 'package:flutter/material.dart';
import 'package:wish_list_client/models/wish_model.dart';
import 'package:wish_list_client/services/wish_service.dart';

class WishProvider with ChangeNotifier {
  final WishService _wishService = WishService();
  List<WishModel> _wishes = [];

  List<WishModel> get wishes => _wishes;

  Future<void> loadWishes(String wishlistId) async {
    try {
      _wishes = await _wishService.findAllInWishlist(wishlistId);
      notifyListeners();
    } catch (e) {
      print('Failed to load wishes: $e');
      rethrow;
    }
  }

  Future<void> createWish({
    required String wishlistId,
    required String title,
    String? description,
    String? imageUrl,
    String? link,
    required WishType type,
  }) async {
    try {
      final wish = await _wishService.create(
        wishlistId: wishlistId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        link: link,
        type: type,
      );
      _wishes.add(wish);
      notifyListeners();
    } catch (e) {
      print('Failed to create wish: $e');
      rethrow;
    }
  }

  Future<void> deleteWish(String id) async {
    try {
      await _wishService.delete(id);
      _wishes.removeWhere((wish) => wish.id == id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete wish: $e');
      rethrow;
    }
  }
}
