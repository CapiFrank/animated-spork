import 'package:flutter/material.dart';
import 'package:project_cipher/models/company.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/model.dart';
import 'package:project_cipher/models/sawed.dart';

class SawedController extends ChangeNotifier {
  Future<List<Sawed>> index() async {
    try {
      final companyId = auth().device?.companyId;
      if (companyId == null) throw Exception("No hay empresa activa.");

      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );

      if (company == null) throw ArgumentError("Empresa no encontrada.");

      return await company.sawed().getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store({
    required String customerId,
    required String woodId,
  }) async {
    try {
      final companyId = auth().device?.companyId;
      if (companyId == null) throw Exception("No hay empresa activa.");

      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );

      if (company == null) throw ArgumentError("Empresa no encontrada.");

      await company.sawed().create({
        'customer_id': customerId,
        'wood_id': woodId,
      });

      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update({
    required String id,
    required String customerId,
    required String woodId,
  }) async {
    try {
      final companyId = auth().device?.companyId;
      if (companyId == null) throw Exception("No hay empresa activa.");

      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );

      if (company == null) throw ArgumentError("Empresa no encontrada.");

      await company.sawed().update(id, {
        'customer_id': customerId,
        'wood_id': woodId,
      });

      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al actualizar: $e');
    }
  }

  Future<void> destroy({required String id}) async {
    try {
      final companyId = auth().device?.companyId;
      if (companyId == null) throw Exception("No hay empresa activa.");

      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );

      if (company == null) throw ArgumentError("Empresa no encontrada.");

      await company.sawed().delete(id);

      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
