import 'package:flutter/material.dart';
import 'package:project_cipher/models/company.dart';
import '../utils/model.dart';
import '../models/wood.dart';

class WoodController extends ChangeNotifier {
  Future<List<Wood>> index(String companyId) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      return await company.woods().getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store(
      {required String companyId,
      required String name,
      required double pricePerInch,
      required double discount}) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      await company.woods().create({
        'name': name,
        'price_per_inch': pricePerInch,
        'discount': discount,
      });
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update(
      {required String companyId,
      required String id,
      required String name,
      required double pricePerInch,
      required double discount}) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      await company.woods().update(id, {
        'name': name,
        'price_per_inch': pricePerInch,
        'discount': discount,
      });
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al actualizar: $e');
    }
  }

  Future<void> destroy({required String id, required String companyId}) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      await company.woods().delete(id);
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
