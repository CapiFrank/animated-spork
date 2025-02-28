import 'dart:io';

String camelCaseToSnakeCase(String input) {
  // Inicializamos una cadena vacía para almacenar el resultado
  String result = '';

  // Recorremos cada carácter de la cadena de entrada
  for (int i = 0; i < input.length; i++) {
    // Obtenemos el carácter actual
    String char = input[i];

    // Si el carácter es una letra mayúscula y no es el primer carácter
    if (char == char.toUpperCase() && i != 0) {
      // Añadimos un guión bajo antes de la letra mayúscula
      result += '_';
    }

    // Añadimos el carácter en minúscula al resultado
    result += char.toLowerCase();
  }

  return result;
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("Por favor, ingresa el nombre del controlador.");
    exit(1); // Salir con un código de error si no se ingresa el nombre
  }

  String controllerName =
      arguments[0]; // El nombre del modelo es el primer argumento

  // Crear el contenido del modelo basado en el nombre
  String modelContent = '''import 'package:flutter/material.dart';

class $controllerName extends ChangeNotifier {
  Future<void> index() async {
  }
  
  Future<void> store(String data) async {
    notifyListeners();
  }

  Future<void> update(String? id, String data) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo");
    }
    notifyListeners();
  }

  Future<void> destroy(String? id) async {
    if (id == null) {
      throw ArgumentError("El ID no puede ser nulo");
    }
    notifyListeners();
  }
}
''';

  // Crear un archivo en el directorio lib/models (o en el lugar que prefieras)
  Directory('lib/controllers').createSync(recursive: true);
  File('lib/controllers/${camelCaseToSnakeCase(controllerName)}.dart')
      .writeAsStringSync(modelContent);

  print(
      "Modelo creado: lib/controllers/${camelCaseToSnakeCase(controllerName)}.dart");
}
