import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/controllers/wood_controller.dart';
import 'package:project_cipher/models/wood.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import 'package:project_cipher/views/layouts/scroll_layout.dart';
import 'package:provider/provider.dart';

class WoodView extends StatefulWidget {
  const WoodView({super.key});

  @override
  WoodViewState createState() => WoodViewState();
}

class WoodViewState extends State<WoodView> {
  late Future<List<Wood>> _data;
  final WoodController _woodController = WoodController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);
    _data = _woodController.index(authController.device!.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Wood>>(
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
            toolbarHeight: 350,
            isEmpty: (snapshot.hasData && snapshot.data!.isEmpty),
            showEmptyMessage: true,
            headerChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Maderas',
                    style: TextStyle(
                      color: Palette(context).onSecondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputText(
                    style: TextStyle(color: Palette(context).onPrimary),
                    decoration: customDecoration(context),
                    textEditingController: _nameController,
                    labelText: "Nombre de la madera",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El campo no puede estar vacío";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    style: TextStyle(color: Palette(context).onPrimary),
                    decoration: customDecoration(context),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    textEditingController: _priceController,
                    labelText: "Precio por pulgada",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El campo no puede estar vacío";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputText(
                    style: TextStyle(color: Palette(context).onPrimary),
                    decoration: customDecoration(context),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    textEditingController: _discountController,
                    labelText: "Descuento",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El campo no puede estar vacío";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SecondaryButton(
                      labelText: "Agregar",
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _priceController.text.isEmpty ||
                            _discountController.text.isEmpty) {
                          ErrorHandler.handleError(
                              'Por favor, completa todos los campos.');
                          return;
                        }
                        _woodController
                            .store(
                                name: _nameController.text,
                                pricePerInch:
                                    double.parse(_priceController.text),
                                discount:
                                    double.parse(_discountController.text),
                                companyId: Provider.of<AuthController>(context,
                                        listen: false)
                                    .device!
                                    .companyId)
                            .then((_) {
                          setState(() {
                            _data = _woodController.index(
                                Provider.of<AuthController>(context,
                                        listen: false)
                                    .device!
                                    .companyId);
                          });
                        });
                      }),
                ],
              ),
            ),
            bodyChild: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final wood = snapshot.data![index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Slidable(
                        key: ValueKey(wood.id),
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
                            title: Text(wood.name),
                            subtitle: Text(
                                'Precio: ₡${wood.pricePerInch} por pulgada\n'
                                'Descuento: ${wood.discount}%'),
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
