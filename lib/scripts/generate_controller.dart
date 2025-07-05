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
        fromJson: $controllerName.fromDoc,
      );
    } catch (e) {
      debugPrint('🔴 Error al obtener datos: \$e');
      return [];
    }
  }

  Future<void> store({required String text}) async {
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

  Future<void> update({required String id, required String newText}) async {
    try {
      var $variableName = await Model.find<$controllerName>(
        collectionName: '$collectionName',
        id: id,
        fromJson: $controllerName.fromDoc
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

  Future<void> destroy({required String id}) async {
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
