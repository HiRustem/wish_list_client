class UserModel {
  final String id;
  final String email;
  final String? nickname;
  final String? avatar;
  final String token;

  UserModel({
    required this.id,
    required this.email,
    this.nickname,
    this.avatar,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      token: json['token'],
    );
  }
}
