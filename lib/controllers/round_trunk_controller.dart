import 'package:flutter/material.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/model.dart';
import 'package:project_cipher/utils/volume_calculator.dart';
import '../models/round_trunk.dart';

class RoundTrunkController extends ChangeNotifier {
  Future<List<RoundTrunk>> index({required Sawed sawed}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      return await Model.relations<RoundTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'round_trunks'
      ], modelBuilder: RoundTrunk.fromDoc)
          .getAll();
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: $e');
      return [];
    }
  }

  Future<void> store(
      {required Sawed sawed,
      required double circumference,
      required double length}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");

      final wood = await company.woods().find(sawed.woodId);
      if (wood == null) throw ArgumentError("Empresa no encontrada.");

      var volume = VolumeCalculator.calculateRoundLogVolume(
          circumference: circumference, length: length);
      var price = wood.price(volume: volume);

      await Model.relations<RoundTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'round_trunks'
      ], modelBuilder: RoundTrunk.fromDoc)
          .create({
        'circumference': circumference,
        'length': length,
        'price': price
      });
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: $e');
    }
  }

  Future<void> update(
      {required Sawed sawed,
      required String id,
      required double circumference,
      required double length,
      required double price,}) async {
    try {
      await auth().loadCompany();

      final company = auth().company;
      if (company == null) throw ArgumentError("Empresa no encontrada.");
      
      await Model.relations<RoundTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'round_trunks'
      ], modelBuilder: RoundTrunk.fromDoc)
          .update(id, {
        'circumference': circumference,
        'length': length,
        'price': price,
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
      await Model.relations<RoundTrunk>([
        [company.collectionName, company.id],
        ['sawed', sawed.id],
        'round_trunks'
      ], modelBuilder: RoundTrunk.fromDoc)
          .delete(id);
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: $e');
    }
  }
}
