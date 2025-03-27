import 'package:flutter/material.dart';

class NumericKeyboard extends StatefulWidget {
  final Function(String) onKeyPressed;

  const NumericKeyboard({super.key, required this.onKeyPressed});

  @override
  _NumericKeyboardState createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  final TextEditingController _controller =
      TextEditingController(); // Controlador para el input

  @override
  Widget build(BuildContext context) {
    List<String> keys = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "←", // Borrar
      "0",
      "✓" // Aceptar
    ];

    return Positioned(
      right: 0, // Siempre alineado a la derecha
      top: 0, // Pegado arriba
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3, // Ajusta el ancho
        height: MediaQuery.of(context).size.height,
        color: Colors.grey,
        child: Column(
          children: [
            // Campo de texto que muestra lo ingresado
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.none, // Deshabilitar teclado nativo
                decoration: InputDecoration(
                  labelText: "Ingrese un valor",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black54,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Teclado numérico
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columnas
                  childAspectRatio: 1.2,
                ),
                itemCount:
                    keys.length, // Números del 0 al 9 + "Borrar" y "Enter"
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onKeyPressed(keys[index]),
                    child: Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          keys[index],
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metodo que maneja la acción al presionar una tecla
  void _onKeyPressed(String key) {
    if (key == "←") {
      // Borrar el último carácter
      if (_controller.text.isNotEmpty) {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      }
    } else if (key == "✓") {
      // Acción para aceptar (puedes personalizarla)
      widget.onKeyPressed(_controller.text);
    } else {
      // Agregar el número presionado
      _controller.text += key;
    }
    setState(() {});
  }
}
