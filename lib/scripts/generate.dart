import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("Por favor, ingresa el nombre base del archivo (ejemplo: 'User').");
    exit(1);
  }

  String baseName = arguments[0]; // El nombre base es el primer argumento

  // Llamar a los scripts para generar el modelo, controlador y vista
  generateModel(baseName);
  generateController(baseName);
  generateView(baseName);
}

void generateModel(String baseName) {
  print("Generando el modelo para $baseName...");
  Process.runSync('dart', ['run', 'lib/scripts/generate_model.dart', baseName]);
}

void generateController(String baseName) {
  print("Generando el controlador para $baseName...");
  Process.runSync(
      'dart', ['run', 'lib/scripts/generate_controller.dart', baseName]);
}

void generateView(String baseName) {
  print("Generando la vista para $baseName...");
  Process.runSync('dart', ['run', 'lib/scripts/generate_view.dart', baseName]);
}
