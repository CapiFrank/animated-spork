import 'dart:io';

String camelCaseToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
    return '${match.group(1)}_${match.group(2)?.toLowerCase()}';
  }).toLowerCase();
}

String pluralize(String word) {
  if (word.endsWith('y')) {
    return '${word.substring(0, word.length - 1)}ies';
  } else if (RegExp(r'(s|x|z|ch|sh)$').hasMatch(word)) {
    return '${word}es';
  }
  return '${word}s';
}

String lowerCamelCase(String input) {
  return input[0].toLowerCase() + input.substring(1);
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    exit(1);
  }

  String controllerName = arguments[0];
  String collectionName = camelCaseToSnakeCase(pluralize(controllerName));
  String variableName = lowerCamelCase(controllerName);

  String controllerContent = '''
import 'package:flutter/material.dart';
import '../utils/model.dart';
import '../models/${camelCaseToSnakeCase(controllerName)}.dart';

class ${controllerName}Controller extends ChangeNotifier {
  Future<List<$controllerName>> index() async {
    try {
      return await Model.all<$controllerName>(
        collectionName: '$collectionName',
        fromJson: (id, data) => $controllerName(
          id: id,
          text: data['text'],
          createdAt: data['created_at'],
          updatedAt: data['updated_at'],
        ),
      );
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: \$e');
      return [];
    }
  }

  Future<void> store(String text) async {
    if (text.trim().isEmpty) {
      throw ArgumentError("El texto no puede estar vacío.");
    }
    try {
      var new$controllerName = $controllerName(
        text: text,
      );
      await new$controllerName.create();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al guardar: \$e');
    }
  }

  Future<void> update(String? id, String newText) async {
    if (id == null || newText.trim().isEmpty) {
      throw ArgumentError("ID y texto son obligatorios.");
    }
    try {
      var $variableName = await Model.find<$controllerName>(
        collectionName: '$collectionName',
        id: id,
        fromJson: (id, data) => $controllerName(
          id: id,
          text: data['text'],
        ),
      );

      if ($variableName != null) {
        await $variableName.update({
          'text': newText,
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('🔴 Error al actualizar: \$e');
    }
  }

  Future<void> destroy(String? id) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo.");
    }
    try {
      var $variableName = await Model.find<$controllerName>(
        collectionName: '$collectionName',
        id: id,
        fromJson: (id, data) => $controllerName(
          id: id,
          text: data['text'],
        ),
      );
      await $variableName?.delete();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error al eliminar: \$e');
    }
  }
}
''';

  Directory('lib/controllers').createSync(recursive: true);
  File('lib/controllers/${camelCaseToSnakeCase(controllerName)}_controller.dart')
      .writeAsStringSync(controllerContent);
}
