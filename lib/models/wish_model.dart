enum WishType { GENERAL, PRODUCT }

class WishModel {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final WishType type;
  final String? link;

  WishModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.type,
    this.link,
  });

  factory WishModel.fromJson(Map<String, dynamic> json) {
    return WishModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      type: WishType.values.firstWhere(
        (e) => e.toString() == 'WishType.${json['type']}',
      ),
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type.toString().split('.').last,
      'link': link,
    };
  }
}
