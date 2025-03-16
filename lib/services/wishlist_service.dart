import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wish_list_client/models/wishlist_model.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';

class WishlistService {
  final String baseUrl = dotenv.get('BASE_URL');

  Future<List<WishlistModel>> findAllByUser(String userId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/wishlist/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => WishlistModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wishlists');
    }
  }

  Future<WishlistModel> create(String userId, String title) async {
    final token = await SharedPrefs.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId, 'title': title}),
    );

    if (response.statusCode == 201) {
      return WishlistModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create wishlist');
    }
  }

  Future<void> delete(String id) async {
    final token = await SharedPrefs.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete wishlist');
    }
  }
}
