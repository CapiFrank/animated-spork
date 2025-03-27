import '../utils/model.dart';

class Costumer extends Model {
  String name;

  Costumer({super.id, required this.name, super.createdAt, super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  Costumer fromJson(Map<String, dynamic> json) {
    return Costumer(
        id: json['id'],
        name: json['name'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  @override
  String get collectionName => "customers";
}
