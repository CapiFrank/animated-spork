import 'package:flutter/material.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/models/customer.dart';

class CustomerController extends ChangeNotifier {
  Future<List<Customer>> index() async {
    try {
      await auth().loadCompany();

      final company = auth().company;

      if (company == null) throw ArgumentError("Empresa no encontrada.");

      return await company.costumers().getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store({
    required String name,
    required String phoneNumber,
  }) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      await company.costumers().create({
        'name': name,
        'phone': phoneNumber,
      });

      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update({
    required String id,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      await company
          .costumers()
          .update(id, {'name': name, 'phone': phoneNumber});
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al actualizar: $e');
    }
  }

  Future<void> destroy({required String id}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      await company.costumers().delete(id);

      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
