import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cipher/controllers/square_trunk_controller.dart';
import 'package:project_cipher/models/company.dart';
import 'package:project_cipher/models/customer.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/models/square_trunk.dart';
import 'package:project_cipher/models/wood.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/utils/pdf_invoice_generator.dart';
import 'package:project_cipher/views/components/detail_card.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import 'package:project_cipher/views/layouts/scroll_layout.dart';
import 'package:project_cipher/views/partials/edit_square_trunk_view.dart';

class SquareTrunkView extends StatefulWidget {
  final Sawed sawed;
  const SquareTrunkView({super.key, required this.sawed});

  @override
  SquareTrunkViewState createState() => SquareTrunkViewState();
}

class SquareTrunkViewState extends State<SquareTrunkView> {
  late Future<List<SquareTrunk>> _data;
  late Sawed sawed;
  final SquareTrunkController _squareTrunkController = SquareTrunkController();
  final TextEditingController _largeController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  late Company company;
  late Customer customer;
  late Wood wood;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadDevices();
  }

  void _loadDevices() {
    setState(() {
      _data = _squareTrunkController.index(sawed: sawed);
    });
  }

  void _loadData() async {
    sawed = widget.sawed;
    company = auth().company!;
    company
        .costumers()
        .find(sawed.customerId)
        .then((item) => (customer = item!));
    company.woods().find(sawed.woodId).then((item) => (wood = item!));
  }

  void _onSubmit() {
    if (_largeController.text.isEmpty ||
        _widthController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ErrorHandler.handleError('Por favor, completa todos los campos.');
      return;
    }
    _squareTrunkController
        .store(
            sawed: sawed,
            quantity: double.parse(_quantityController.text),
            thickness: double.parse(_heightController.text),
            width: double.parse(_widthController.text),
            length: double.parse(_largeController.text))
        .then((_) {
      setState(() {
        _data = _squareTrunkController.index(sawed: sawed);
        _quantityController.clear();
        _heightController.clear();
        _widthController.clear();
        _largeController.clear();
      });
    }).catchError((error) {
      ErrorHandler.handleError('Error al agregar el cliente: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<SquareTrunk>>(
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Botón alineado a la derecha
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.picture_as_pdf_sharp,
                          color: Palette(context).onSecondary,
                        ),
                        onPressed: () async {
                          var trunks = await _data;

                          await PdfInvoiceGenerator.build(
                            supplier: [
                              ['Nombre:', company.name],
                              ['NIF:', company.nif],
                              ['Número de telefono:', company.phoneNumber]
                            ],
                            customer: [
                              ['Nombre:', customer.name],
                              ['Número de telefono:', customer.phoneNumber]
                            ],
                            invoiceTable: [
                              [
                                'Unidades',
                                'Madera',
                                'Espesor',
                                'Largo',
                                'Ancho',
                                'Volumen',
                                'Precio',
                              ],
                              ...trunks.map((trunk) => [
                                    trunk.quantity.toString(),
                                    wood.name,
                                    trunk.thickness.toString(),
                                    trunk.length.toString(),
                                    trunk.width.toString(),
                                    trunk.volumePerUnit.toString(),
                                    trunk.price.toString()
                                  ])
                            ],
                            columnsToSum: [
                              'Unidades',
                              'Espesor',
                              'Largo',
                              'Ancho',
                              'Volumen',
                              'Precio',
                            ],
                            totalLabel: 'Total:',
                          );
                        },
                      ),
                    ),
                    // Texto centrado
                    Text(
                      'Tronco Cuadrado',
                      style: TextStyle(
                        color: Palette(context).onSecondary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Botón alineado a la izquierda
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Palette(context).onSecondary,
                        ),
                        onPressed: () {
                          GoRouter.of(context)
                              .pop(); // o Navigator.of(context).pop();
                        },
                      ),
                    ),
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
                        textInputAction: TextInputAction.next,
                        cursorColor: Palette(context).onPrimary,
                        style: TextStyle(color: Palette(context).onPrimary),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: customDecoration(context),
                        textEditingController: _heightController,
                        labelText: "Espesor",
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
                        textInputAction: TextInputAction.next,
                        cursorColor: Palette(context).onPrimary,
                        style: TextStyle(color: Palette(context).onPrimary),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: customDecoration(context),
                        textEditingController: _widthController,
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
                        textInputAction: TextInputAction.next,
                        cursorColor: Palette(context).onPrimary,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        style: TextStyle(color: Palette(context).onPrimary),
                        decoration: customDecoration(context),
                        textEditingController: _largeController,
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
                        textInputAction: TextInputAction.send,
                        cursorColor: Palette(context).onPrimary,
                        style: TextStyle(color: Palette(context).onPrimary),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Solo acepta dígitos 0-9
                        ],
                        decoration: customDecoration(context),
                        textEditingController: _quantityController,
                        labelText: "Cantidad",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El campo no puede estar vacío";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _onSubmit();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SecondaryButton(labelText: "Agregar", onPressed: _onSubmit),
              ],
            ),
            bodyChild: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final squareTrunk = snapshot.data![index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Slidable(
                          key: ValueKey(squareTrunk.id),
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Palette(context).surface,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => EditSquareTrunkModal(
                                      sawed: sawed,
                                      squareTrunk: squareTrunk,
                                      onSuccess: () {
                                        context.pop();
                                        setState(() {
                                          _data = _squareTrunkController.index(
                                              sawed: sawed);
                                        });
                                      },
                                    ),
                                  );
                                },
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
                                onPressed: () => _squareTrunkController
                                    .destroy(id: squareTrunk.id!, sawed: sawed)
                                    .then((_) {
                                  setState(() {
                                    _data = _squareTrunkController.index(
                                        sawed: sawed);
                                  });
                                }).catchError((error) {
                                  ErrorHandler.handleError(
                                      'Error al eliminar: $error');
                                }),
                                icon: Icons.delete,
                                label: 'Eliminar',
                                color: Colors.red,
                              ),
                            ],
                          ),
                          child:
                              DetailCard(title: 'Detalles de la Pieza', items: [
                            DetailItem(
                                label: 'Espesor',
                                value: squareTrunk.thickness.toString()),
                            DetailItem(
                                label: 'Ancho',
                                value: squareTrunk.width.toString()),
                            DetailItem(
                                label: 'Largo',
                                value: squareTrunk.length.toString()),
                            DetailItem(
                                label: 'Cantidad',
                                value: squareTrunk.quantity.toString()),
                            DetailItem(
                                label: 'Volumen',
                                value: squareTrunk.volumePerUnit.toString()),
                            DetailItem(
                                label: 'Total',
                                value: squareTrunk.totalVolume.toString()),
                            DetailItem(
                                label: 'Precio',
                                value: squareTrunk.price.toString()),
                            DetailItem(
                                label: 'Precio Total',
                                value: squareTrunk.totalPrice.toString()),
                          ])));
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
