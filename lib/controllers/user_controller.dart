import 'package:flutter/material.dart';
import '../models/model.dart';
import '../utils/hash.dart';
import '../models/user.dart';

class CompanyController extends ChangeNotifier {
  // ✅ Obtener todos los usuarios
  Future<List<User>> index() async {
    return await Model.all<User>(
        collectionName: 'companies',
        fromJson: (id, data) => User(
            id: id,
            name: data['name'],
            email: data['email'],
            password: data['password'],
            createdAt: data['created_at'],
            updatedAt: data['updated_at']));
  }

  // ✅ Crear usuario
  Future<void> store(String name, String email, String password) async {
    var newUser = User(name: name, email: email, password: Hash.make(password));
    await newUser.create();
    notifyListeners(); // Notifica cambios a la vista
  }

  // ✅ Actualizar usuario
  Future<void> update(String? id, String newName) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo");
    }
    var user = await Model.find<User>(
      collectionName: 'users',
      id: id,
      fromJson: (id, data) => User(
          id: id,
          name: data['name'],
          email: data['email'],
          password: data['password']),
    );
    await user?.update({'name': newName});
    notifyListeners();
  }

  // ✅ Eliminar usuario
  Future<void> destroy(String? id) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo");
    }
    var user = await Model.find<User>(
      collectionName: 'users',
      id: id,
      fromJson: (id, data) => User(
          id: id,
          name: data['name'],
          email: data['email'],
          password: data['password']),
    );
    user?.delete();
    notifyListeners();
  }
}
