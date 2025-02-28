import 'package:project_cipher/models/post.dart';

import 'model.dart';

class User extends Model {
  String name;
  String email;
  String password;

  User(
      {super.id,
      required this.name,
      required this.email,
      required this.password,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };

  @override
  User fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  @override
  String get collectionName => "users";

  Future<List<Post>> posts() async {
    return await getDocumentsByField(
        collection: 'posts',
        field: 'user_id',
        value: id,
        fromJson: (id, data) => Post(
            id: id,
            text: data['text'],
            userId: data['user_id'],
            createdAt: data['created_at'],
            updatedAt: data['updated_at']));
  }
}
