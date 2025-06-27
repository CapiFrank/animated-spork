import 'package:flutter/material.dart';
import 'package:project_cipher/models/company.dart';
import '../utils/model.dart';
import '../models/sawed.dart';

class SawedController extends ChangeNotifier {
  Future<List<Sawed>> index(String companyId) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      return await company.sawed().getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store(
      {required String companyId,
      required String customerId,
      required String woodId}) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      await company.sawed().create({
        'customer_id': customerId,
        'wood_id': woodId,
      });
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update(
      {required String companyId,
      required String id,
      required String customerId,
      required String woodId}) async {
    try {
      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );
      if (company == null) {
        throw ArgumentError("Empresa no encontrada.");
      }
      await company.sawed().update(id, {
        'customer_id': customerId,
        'wood_id': woodId,
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
      await company.sawed().delete(id);
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
