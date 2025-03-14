class UserModel {
  final String id;
  final String email;
  final String? nickname;
  final String? avatar;

  UserModel({
    required this.id,
    required this.email,
    this.nickname,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      avatar: json['avatar'],
    );
  }
}
