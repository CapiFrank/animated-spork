import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_cipher/utils/error_handler.dart';
import '../utils/model.dart';
import '../models/device.dart';

class DeviceController extends ChangeNotifier {
  Future<List<Device>> index() async {
    try {
      return await Model.all<Device>(
        collectionName: 'devices',
        fromJson: Device.fromDoc,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
      return [];
    }
  }

  Future<void> store(
      String text,
      String email,
      String password,
      String customerId,
      String companyId,
      String token,
      String info,
      String version,
      bool useInternationalSystem,
      bool active,
      Timestamp expiresAt,
      Timestamp createdAt,
      Timestamp updatedAt) async {
    if (text.trim().isEmpty) {
      throw ArgumentError("El texto no puede estar vacío.");
    }
    try {
      var newDevice = Device(
        name: text,
        email: email,
        password: password,
        customerId: customerId,
        companyId: companyId,
        active: active,
        token: token,
        expiresAt: expiresAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        info: info,
        version: version,
        useInternationalSystem: useInternationalSystem,
      );
      await newDevice.create();
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<void> update(String? id, String newText) async {
    if (id == null || newText.trim().isEmpty) {
      throw ArgumentError("ID y texto son obligatorios.");
    }
    try {
      var device = await Model.find<Device>(
        collectionName: 'devices',
        id: id,
        fromJson: Device.fromDoc,
      );

      if (device != null) {
        await device.update({
          'name': newText,
        });
        notifyListeners();
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<void> destroy(String? id) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo.");
    }
    try {
      var device = await Model.find<Device>(
        collectionName: 'devices',
        id: id,
        fromJson: Device.fromDoc,
      );
      await device?.delete();
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
