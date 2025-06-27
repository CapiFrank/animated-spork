import 'package:project_cipher/models/customer.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/models/wood.dart';
import 'package:project_cipher/utils/subcollection.dart';

import '../utils/model.dart';

class Company extends Model {
  String name;
  String customerId;
  String email;
  String fiscalName;
  String password;
  String nif;
  String phoneNumber;

  Company(
      {super.id,
      required this.name,
      required this.customerId,
      required this.email,
      required this.fiscalName,
      required this.nif,
      required this.password,
      required this.phoneNumber,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'email': email,
      'password': password,
      'fiscal_name': fiscalName,
      'name': name,
      'nif': nif,
      'phone_number': phoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Subcollection<Customer> costumers() {
    return Subcollection<Customer>(
        parentCollection: collectionName,
        parentId: id!,
        subcollectionName: 'customers',
        modelBuilder: Customer.fromDoc);
  }

  Subcollection<Wood> woods() {
    return Subcollection<Wood>(
        parentCollection: collectionName,
        parentId: id!,
        subcollectionName: 'woods',
        modelBuilder: Wood.fromDoc);
  }

  Subcollection<Sawed> sawed() {
    return Subcollection<Sawed>(
        parentCollection: collectionName,
        parentId: id!,
        subcollectionName: 'sawed',
        modelBuilder: Sawed.fromDoc);
  }

  @override
  Company fromJson(Map<String, dynamic> json) {
    return Company(
        name: json['name'],
        customerId: json['customer_id'],
        email: json['email'],
        fiscalName: json['fiscal_name'],
        nif: json['nif'],
        password: json['password'],
        phoneNumber: json['phone_number'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  static Company fromDoc(id, data) {
    return Company(
        id: id,
        name: data['name'],
        customerId: data['customer_id'],
        email: data['email'],
        fiscalName: data['fiscal_name'],
        nif: data['nif'],
        password: data['password'],
        phoneNumber: data['phone_number'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  @override
  String get collectionName => "companies";
}
