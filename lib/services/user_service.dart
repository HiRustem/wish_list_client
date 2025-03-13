import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:wish_list_client/utils/shared_prefs.dart';

class UserService {
  final String baseUrl = dotenv.get('BASE_URL');

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String nickname,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<UserModel> getCurrentUser() async {
    final token = await SharedPrefs.getToken();

    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<UserModel> getUserById(String id) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load urser');
    }
  }

  Future<UserModel> updateAvatar(String userId, String avatarUrl) async {
    final token = await SharedPrefs.getToken();

    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId/avatar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'avatarUrl': avatarUrl}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update avatar');
    }
  }

  Future<void> followUser(String followerId, String followingId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/users/follow'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'followerId': followerId, 'followingId': followingId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to follow user');
    }
  }

  Future<void> unfollowUser(String followerId, String followingId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/users/unfollow'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'followerId': followerId, 'followingId': followingId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow user');
    }
  }
}
