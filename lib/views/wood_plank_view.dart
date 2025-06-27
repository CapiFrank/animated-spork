import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import 'package:project_cipher/views/layouts/scroll_layout.dart';
import '../controllers/device_controller.dart';
import '../models/device.dart';

class WoodPlankView extends StatefulWidget {
  const WoodPlankView({super.key});

  @override
  WoodPlankViewState createState() => WoodPlankViewState();
}

class WoodPlankViewState extends State<WoodPlankView> {
  late Future<List<Device>> _data;
  final DeviceController _deviceController = DeviceController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    setState(() {
      _data = _deviceController.index();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Device>>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ErrorHandler.handleError(
                'Error: ${snapshot.error?.toString() ?? "Desconocido"}');
          });
          return const Center(
              child: Text('Ocurrió un error al cargar los dispositivos.'));
        } else {
          return ScrollLayout(
            isEmpty: (snapshot.hasData && snapshot.data!.isEmpty),
            showEmptyMessage: true,
            headerChild: Column(
              children: [
                Text(
                  'Tablas',
                  style: TextStyle(
                    color: Palette(context).onSecondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputText(
                        style: TextStyle(color: Palette(context).onPrimary),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: customDecoration(context),
                        textEditingController: TextEditingController(),
                        labelText: "Alto",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El campo no puede estar vacío";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InputText(
                        style: TextStyle(color: Palette(context).onPrimary),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: customDecoration(context),
                        textEditingController: TextEditingController(),
                        labelText: "Ancho",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El campo no puede estar vacío";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputText(
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        style: TextStyle(color: Palette(context).onPrimary),
                        decoration: customDecoration(context),
                        textEditingController: TextEditingController(),
                        labelText: "Largo",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El campo no puede estar vacío";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InputText(
                        style: TextStyle(color: Palette(context).onPrimary),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Solo acepta dígitos 0-9
                        ],
                        decoration: customDecoration(context),
                        textEditingController: TextEditingController(),
                        labelText: "Cantidad",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El campo no puede estar vacío";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SecondaryButton(labelText: "Agregar", onPressed: () {}),
              ],
            ),
            bodyChild: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final device = snapshot.data![index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Slidable(
                        key: ValueKey(device.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableButton(
                              onPressed: () => debugPrint("Editar"),
                              icon: Icons.edit,
                              label: 'Editar',
                              color: Colors.green,
                            )
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableButton(
                              onPressed: () => debugPrint("Eliminar"),
                              icon: Icons.delete,
                              label: 'Eliminar',
                              color: Colors.red,
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: ListTile(
                            title: Text(device.name),
                            subtitle: Text('ID: ${device.id}'),
                          ),
                        ),
                      ));
                },
                childCount: snapshot.data!.length,
              ),
            ),
          );
        }
      },
    ));
  }
}

InputDecoration customDecoration(BuildContext context) {
  return InputDecoration(
    labelStyle: TextStyle(color: Palette(context).onSecondary),
    suffixIconColor: Palette(context).onSecondary,
    fillColor: Palette(context).secondary,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).outline),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).errorContainer),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).error),
    ),
  );
}
