import 'package:wish_list_client/models/wish_model.dart';

class WishlistModel {
  final String id;
  final String title;
  final List<WishModel> wishes;

  WishlistModel({required this.id, required this.title, required this.wishes});

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(id: json['id'], title: json['title'], wishes: []);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
