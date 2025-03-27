import 'package:flutter/material.dart';
import '../utils/model.dart';
import '../models/company.dart';

class CompanyController extends ChangeNotifier {
  Future<List<Company>> index() async {
    try {
      return await Model.all<Company>(
        collectionName: 'companies',
        fromJson: (id, data) => Company(
          id: id,
          name: data['name'],
          createdAt: data['created_at'],
          updatedAt: data['updated_at'],
        ),
      );
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store(String text) async {
    if (text.trim().isEmpty) {
      throw ArgumentError("El texto no puede estar vacío.");
    }
    try {
      var newCompany = Company(
        name: text,
      );
      await newCompany.create();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update(String? id, String newText) async {
    if (id == null || newText.trim().isEmpty) {
      throw ArgumentError("ID y texto son obligatorios.");
    }
    try {
      var company = await Model.find<Company>(
        collectionName: 'companies',
        id: id,
        fromJson: (id, data) => Company(
          id: id,
          name: data['name'],
        ),
      );

      if (company != null) {
        await company.update({
          'name': newText,
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
        fromJson: (id, data) => Company(
          id: id,
          name: data['name'],
        ),
      );
      await company?.delete();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
