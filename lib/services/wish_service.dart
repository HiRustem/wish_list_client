import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wish_list_client/models/wish_model.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';

class WishService {
  final String baseUrl = dotenv.get('BASE_URL');

  Future<List<WishModel>> findAllInWishlist(String wishlistId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/wish/$wishlistId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => WishModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wishes');
    }
  }

  Future<WishModel> create({
    required String wishlistId,
    required String title,
    String? description,
    String? imageUrl,
    String? link,
    required WishType type,
  }) async {
    final token = await SharedPrefs.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/wish'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'wishlistId': wishlistId,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'link': link,
        'type': type.toString().split('.').last,
      }),
    );

    if (response.statusCode == 201) {
      return WishModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create wish');
    }
  }

  Future<void> delete(String id) async {
    final token = await SharedPrefs.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/wish/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete wish');
    }
  }
}
