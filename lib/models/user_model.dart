class UserModel {
  final String id;
  final String email;
  final String? nickname;
  final String? avatar;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.nickname,
    this.avatar,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserStats {
  final int followersCount;
  final int followingCount;

  UserStats({required this.followersCount, required this.followingCount});

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
    );
  }
}
