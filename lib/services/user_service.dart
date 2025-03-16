import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/models/wishlist_model.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';

class UserService {
  final String baseUrl = dotenv.get('BASE_URL');

  Future<UserModel> getCurrentUser() async {
    final token = await SharedPrefs.getToken();

    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
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
      throw Exception('Failed to load user');
    }
  }

  Future<List<UserModel>> getUsersByNickname(String nickname) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users?nickname=$nickname'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw Exception('Failed to find any users!');
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

  Future<List<WishlistModel>> getUserWishlists(String userId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/wishlists'),
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

    final response = await http.delete(
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

  Future<List<UserModel>> getFollowers(String userId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/followers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followers');
    }
  }

  Future<List<UserModel>> getFollowing(String userId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/following'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load following');
    }
  }

  Future<bool> isFollowing(String followerId, String followingId) async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/users/$followerId/is-following/$followingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isFollowing'];
    } else {
      throw Exception('Failed to check follow status');
    }
  }
}
