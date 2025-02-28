import 'package:project_cipher/models/user.dart';

import 'model.dart';

class Post extends Model {
  String text;
  String userId;

  Post(
      {super.id,
      required this.text,
      required this.userId,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() => {'text': text, 'user_id': userId};

  @override
  Post fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        text: json['text'],
        userId: json['user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  @override
  String get collectionName => "posts";

  Future<User?> user() async {
    return await Model.find<User>(
        collectionName: 'users',
        id: userId,
        fromJson: (id, data) => User(
            id: id,
            name: data['name'],
            email: data['email'],
            password: data['password'],
            createdAt: data['created_at'],
            updatedAt: data['updated_at']));
  }
}
