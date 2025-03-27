import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/model.dart';

class Device extends Model {
  String name;
  String email;
  String password;
  String customerId;
  String companyId;
  bool active;
  String? token;
  Timestamp? expiresAt;

  Device(
      {super.id,
      required this.name,
      required this.email,
      required this.password,
      required this.customerId,
      required this.companyId,
      required this.active,
      required this.token,
      required this.expiresAt,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'customer_id': customerId,
      'company_id': companyId,
      'active': active,
      'token': token,
      'expires_at': expiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  Device fromJson(Map<String, dynamic> json) {
    return Device(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        customerId: json['customer_id'],
        companyId: json['company_id'],
        active: json['active'],
        token: json['token'],
        expiresAt: json['expires_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  static Device fromDoc(id, data) {
    return Device(
        id: id,
        name: data['name'],
        email: data['email'],
        password: data['password'],
        customerId: data['customer_id'],
        companyId: data['company_id'],
        active: data['active'],
        token: data['token'],
        expiresAt: data['expires_at'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  @override
  String get collectionName => "devices";
}
