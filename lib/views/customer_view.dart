import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import 'package:project_cipher/views/layouts/scroll_layout.dart';
import 'package:provider/provider.dart';
import '../controllers/customer_controller.dart';
import '../models/customer.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  CustomerViewState createState() => CustomerViewState();
}

class CustomerViewState extends State<CustomerView> {
  late Future<List<Customer>> _data;
  final CustomerController _costumerController = CustomerController();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late String companyId;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    final authController = Provider.of<AuthController>(context, listen: false);
    companyId = authController.device!.companyId;
    _data = _costumerController.index(companyId);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Customer>>(
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
                  'Clientes',
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
                  textEditingController: nameController,
                  labelText: "Nombre completo",
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
                  textEditingController: phoneController,
                  labelText: "Número de teléfono",
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
                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty) {
                        ErrorHandler.handleError(
                            'Por favor, completa todos los campos.');
                        return;
                      }
                      _costumerController
                          .store(
                              name: nameController.text,
                              phoneNumber: phoneController.text,
                              companyId: companyId)
                          .then((_) {
                        setState(() {
                          _data = _costumerController.index(
                              Provider.of<AuthController>(context,
                                      listen: false)
                                  .device!
                                  .companyId);
                          nameController.clear();
                          phoneController.clear();
                        });
                      }).catchError((error) {
                        ErrorHandler.handleError(
                            'Error al agregar el cliente: $error');
                      });
                    }),
              ],
            ),
            bodyChild: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final customer = snapshot.data![index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Slidable(
                        key: ValueKey(customer.id),
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
                              onPressed: () => _costumerController
                                  .destroy(
                                      id: customer.id!, companyId: companyId)
                                  .then((_) {
                                setState(() {
                                  _data = _costumerController.index(
                                      Provider.of<AuthController>(context,
                                              listen: false)
                                          .device!
                                          .companyId);
                                });
                              }).catchError((error) {
                                ErrorHandler.handleError(
                                    'Error al eliminar el cliente: $error');
                              }),
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
                            title: Text(customer.name),
                            subtitle: Text('Teléfono: ${customer.phoneNumber}'),
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
