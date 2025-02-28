import 'dart:io';

String pluralize(String word) {
  // Regla 1: Si termina en 'y', reemplazar 'y' con 'ies'
  if (word.endsWith('y')) {
    return word.substring(0, word.length - 1) + 'ies';
  }
  // Regla 2: Si termina en 's', 'x', 'z', 'ch', o 'sh', agregar 'es'
  else if (word.endsWith('s') ||
      word.endsWith('x') ||
      word.endsWith('z') ||
      word.endsWith('ch') ||
      word.endsWith('sh')) {
    return word + 'es';
  }
  // Regla 3: En otros casos, agregar 's'
  else {
    return word + 's';
  }
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("Por favor, ingresa el nombre del modelo.");
    exit(1); // Salir con un código de error si no se ingresa el nombre
  }

  String modelName =
      arguments[0]; // El nombre del modelo es el primer argumento

  String collectionName = pluralize(modelName.toLowerCase());

  // Crear el contenido del modelo basado en el nombre
  String modelContent = '''import 'model.dart';

class $modelName extends Model {

  $modelName(
      {super.id,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  $modelName fromJson(Map<String, dynamic> json) {
    return $modelName(
        id: json['id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  @override
  String get collectionName => "$collectionName";
}
''';

  // Crear un archivo en el directorio lib/models (o en el lugar que prefieras)
  Directory('lib/models').createSync(recursive: true);
  File('lib/models/${modelName.toLowerCase()}.dart')
      .writeAsStringSync(modelContent);

  print("Modelo creado: lib/models/$modelName.dart");
}
