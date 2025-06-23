import 'dart:io';

/// Convierte un nombre en CamelCase a snake_case
String camelCaseToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
    return '${match.group(1)}_${match.group(2)?.toLowerCase()}';
  }).toLowerCase();
}

/// Convierte un nombre en PascalCase a lowerCamelCase
String lowerCamelCase(String input) {
  if (input.isEmpty) return input;
  return input[0].toLowerCase() + input.substring(1);
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    exit(1);
  }

  String viewName = arguments[0]; // El nombre de la vista
  String snakeCaseName = camelCaseToSnakeCase(viewName);
  String lowerCamelName = lowerCamelCase(viewName);

  // Contenido de la vista con conexión al controlador
  String viewContent = '''
import 'package:flutter/material.dart';
import '../controllers/${snakeCaseName}_controller.dart';
import '../models/$snakeCaseName.dart';

class ${viewName}View extends StatefulWidget {
  const ${viewName}View({super.key});

  @override
  _${viewName}ViewState createState() => _${viewName}ViewState();
}

class _${viewName}ViewState extends State<${viewName}View> {
  late Future<List<$viewName>> _data;
  final ${viewName}Controller _${lowerCamelName}Controller = ${viewName}Controller();

  @override
  void initState() {
    super.initState();
    _data = _${lowerCamelName}Controller.index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$viewName'),
      ),
      body: FutureBuilder<List<$viewName>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("⚠️ Error: \${snapshot.error}");
            return Center(child: Text('Error: \${snapshot.error?.toString() ?? "Desconocido"}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].text),
                );
              },
            );
          } else {
            return const Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
    );
  }
}
''';

  // Crear el archivo en lib/views
  Directory('lib/views').createSync(recursive: true);
  File('lib/views/${snakeCaseName}_view.dart').writeAsStringSync(viewContent);
}
