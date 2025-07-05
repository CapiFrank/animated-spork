import 'package:flutter/material.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/model.dart';
import 'package:project_cipher/utils/volume_calculator.dart';
import '../models/square_trunk.dart';

class SquareTrunkController extends ChangeNotifier {
  Future<List<SquareTrunk>> index({required Sawed sawed}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      return await Model.relations<SquareTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'square_trunks'
      ], modelBuilder: SquareTrunk.fromDoc)
          .getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store(
      {required Sawed sawed,
      required double thickness,
      required double width,
      required double length,
      required double quantity}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");

      final wood = await company.woods().find(sawed.woodId);
      if (wood == null) throw ArgumentError("Empresa no encontrada.");

      var volume = VolumeCalculator.calculateSquareLogVolume(
          thickness: thickness, width: width, length: length);
      var price = wood.price(volume: volume);

      await Model.relations<SquareTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'square_trunks'
      ], modelBuilder: SquareTrunk.fromDoc)
          .create({
        'thickness': thickness,
        'width': width,
        'length': length,
        'quantity': quantity,
        'price': price,
        'total_price': price * quantity,
      });
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update(
      {required String id,
      required Sawed sawed,
      required double thickness,
      required double width,
      required double length,
      required double price,
      required double quantity}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");

      var totalPrice = price*quantity;

      await Model.relations<SquareTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'square_trunks'
      ], modelBuilder: SquareTrunk.fromDoc)
          .update(id, {
        'thickness': thickness,
        'width': width,
        'length': length,
        'quantity': quantity,
        'price': price,
        'total_price': totalPrice,
      });
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al actualizar: $e');
    }
  }

  Future<void> destroy({required Sawed sawed, required String id}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      await Model.relations<SquareTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'square_trunks'
      ], modelBuilder: SquareTrunk.fromDoc)
          .delete(id);
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
