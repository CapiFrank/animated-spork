import 'package:flutter/material.dart';
import '../utils/model.dart';
import '../models/costumer.dart';

class CostumerController extends ChangeNotifier {
  Future<List<Costumer>> index() async {
    try {
      return await Model.all<Costumer>(
        collectionName: 'costumers',
        fromJson: (id, data) => Costumer(
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
      var newCostumer = Costumer(
        name: text,
      );
      await newCostumer.create();
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
      var costumer = await Model.find<Costumer>(
        collectionName: 'costumers',
        id: id,
        fromJson: (id, data) => Costumer(
          id: id,
          name: data['name'],
        ),
      );

      if (costumer != null) {
        await costumer.update({
          'text': newText,
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
      var costumer = await Model.find<Costumer>(
        collectionName: 'costumers',
        id: id,
        fromJson: (id, data) => Costumer(
          id: id,
          name: data['name'],
        ),
      );
      await costumer?.delete();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
