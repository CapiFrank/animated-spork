import 'package:flutter/material.dart';
import '../utils/model.dart';
import '../models/company.dart';

class CompanyController extends ChangeNotifier {
  Future<List<Company>> index() async {
    try {
      return await Model.all<Company>(
        collectionName: 'companies',
        fromJson: Company.fromDoc,
      );
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store({
    required String name,
    required String customerId,
    required String email,
    required String fiscalName,
    required String nif,
    required String password,
    required String phoneNumber,
  }) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      throw ArgumentError(
          "Los campos nombre, email y contraseña no pueden estar vacíos.");
    }
    try {
      var newCompany = Company(
        name: name,
        customerId: customerId,
        email: email,
        fiscalName: fiscalName,
        nif: nif,
        password: password,
        phoneNumber: phoneNumber,
      );
      await newCompany.create();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update({
    required String id,
    required String name,
    required String customerId,
    required String email,
    required String fiscalName,
    required String nif,
    required String password,
    required String phoneNumber,
  }) async {
    if (id.trim().isEmpty ||
        name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      throw ArgumentError("ID, nombre, email y contraseña son obligatorios.");
    }
    try {
      var company = await Model.find<Company>(
        collectionName: 'companies',
        id: id,
        fromJson: Company.fromDoc,
      );

      if (company != null) {
        await company.update({
          'name': name,
          'customer_id': customerId,
          'email': email,
          'fiscal_name': fiscalName,
          'nif': nif,
          'password': password,
          'phone_number': phoneNumber,
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('🔴 Error al actualizar: $e');
    }
  }

  Future<void> destroy(String? id) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo.");
    }
    try {
      var company = await Model.find<Company>(
        collectionName: 'companies',
        id: id,
        fromJson: Company.fromDoc,
      );
      await company?.delete();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
