import '../utils/model.dart';

class Customer extends Model {
  String name;
  String phoneNumber;

  Customer({super.id, required this.name, required this.phoneNumber, super.createdAt, super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }


  @override
  Customer fromJson(Map<String, dynamic> json) {
    return Customer(
        name: json['name'],
        phoneNumber: json['phone'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  static Customer fromDoc(id, data) {
    return Customer(
        id: id,
        name: data['name'],
        phoneNumber: data['phone'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  @override
  String get collectionName => "customers";
}
