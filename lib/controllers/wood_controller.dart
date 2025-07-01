import 'package:flutter/material.dart';
import 'package:project_cipher/models/company.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/model.dart';
import 'package:project_cipher/models/wood.dart';

class WoodController extends ChangeNotifier {
  Future<List<Wood>> index() async {
    try {
      final companyId = auth().device?.companyId;
      if (companyId == null) throw Exception("No hay empresa activa.");

      Company? company = await Model.find<Company>(
        collectionName: 'companies',
        id: companyId,
        fromJson: Company.fromDoc,
      );

      if (company == null) throw ArgumentError("Empresa no encontrada.");

      return await company.woods().getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store({
    required String name,
    required double pricePerInch,
    required double discount,
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

  Future<void> update({
    required String id,
    required String name,
    required double pricePerInch,
    required double discount,
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

      await company.woods().delete(id);

      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
