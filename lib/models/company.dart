import '../utils/model.dart';

class Company extends Model {
  String name;

  Company({super.id, required this.name, super.createdAt, super.updatedAt});

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
  Company fromJson(Map<String, dynamic> json) {
    return Company(
        id: json['id'],
        name: json['name'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  @override
  String get collectionName => "companies";
}
