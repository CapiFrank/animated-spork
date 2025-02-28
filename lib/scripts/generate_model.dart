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

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("❌ Error: Debes ingresar el nombre del modelo.");
    exit(1);
  }

  String modelName = arguments[0].trim();
  if (modelName.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(modelName)) {
    print("❌ Error: Nombre de modelo inválido. Usa solo letras.");
    exit(1);
  }

  String collectionName = camelCaseToSnakeCase(pluralize(modelName));
  String fileName = camelCaseToSnakeCase(modelName);

  // Crear el contenido del modelo basado en el nombre
  String modelContent = '''import 'model.dart';

class $modelName extends Model {
String text;

  $modelName(
      {super.id,
      required this.text,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  $modelName fromJson(Map<String, dynamic> json) {
    return $modelName(
        id: json['id'],
        text: json['text'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  @override
  String get collectionName => "$collectionName";
}
''';

  // Crear un archivo en el directorio lib/models (o en el lugar que prefieras)
  Directory('lib/models').createSync(recursive: true);
  File('lib/models/$fileName.dart').writeAsStringSync(modelContent);

  print("✅ Modelo creado exitosamente: lib/models/$fileName.dart");
}
