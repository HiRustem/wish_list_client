import 'package:flutter/material.dart';
import 'package:wish_list_client/models/wishlist_model.dart';
import 'package:wish_list_client/services/wishlist_service.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();
  List<WishlistModel> _wishlists = [];
  Map<String, List<WishlistModel>> _userWishlists = {};

  List<WishlistModel> get wishlists => _wishlists;

  Future<void> loadWishlists(String userId) async {
    try {
      _wishlists = await _wishlistService.findAllByUser(userId);
      _userWishlists[userId] = _wishlists;
      notifyListeners();
    } catch (e) {
      print('Failed to load wishlists: $e');
      rethrow;
    }
  }

  List<WishlistModel> getWishlistsByUser(String userId) {
    return _userWishlists[userId] ?? [];
  }

  Future<void> createWishlist(String userId, String title) async {
    try {
      final wishlist = await _wishlistService.create(userId, title);
      _wishlists.add(wishlist);
      notifyListeners();
    } catch (e) {
      print('Failed to create wishlist: $e');
      rethrow;
    }
  }

  Future<void> deleteWishlist(String id) async {
    try {
      await _wishlistService.delete(id);
      _wishlists.removeWhere((wishlist) => wishlist.id == id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete wishlist: $e');
      rethrow;
    }
  }
}
