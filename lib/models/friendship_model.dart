import 'package:wish_list_client/models/user_model.dart';

class FriendshipModel {
  final String id;
  final UserModel follower;
  final UserModel following;
  final DateTime createdAt;

  FriendshipModel({
    required this.id,
    required this.follower,
    required this.following,
    required this.createdAt,
  });

  factory FriendshipModel.fromJson(Map<String, dynamic> json) {
    return FriendshipModel(
      id: json['id'],
      follower: UserModel.fromJson(json['follower']),
      following: UserModel.fromJson(json['following']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'follower': follower.toJson(),
      'following': following.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
