import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/controllers/customer_controller.dart';
import 'package:project_cipher/controllers/sawed_controller.dart';
import 'package:project_cipher/controllers/wood_controller.dart';
import 'package:project_cipher/models/customer.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/models/wood.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/dropdown_search.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import 'package:project_cipher/views/layouts/scroll_layout.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';

class SawedView extends StatefulWidget {
  const SawedView({super.key});

  @override
  SawedViewState createState() => SawedViewState();
}

class SawedViewState extends State<SawedView> {
  late Future<List<Sawed>> _data;
  late Future<List<Customer>> _customerData;
  late Future<List<Wood>> _woodData;
  final SawedController _sawedController = SawedController();
  final CustomerController _customerController = CustomerController();
  final WoodController _woodController = WoodController();

  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);
    _data = _sawedController.index(authController.device!.companyId);
    _customerData = _customerController.index(authController.device!.companyId);
    _woodData = _woodController.index(authController.device!.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Sawed>>(
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
                  'Aserrado',
                  style: TextStyle(
                    color: Palette(context).onSecondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                /// Dropdown de clientes
                FutureBuilder<List<Customer>>(
                  future: _customerData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownSearch<Customer>(
                      context: context,
                      label: "Selecciona un cliente",
                      items: (filter, lp) => snapshot.data!,
                      selectedItem: snapshot.data!.first,
                      itemAsString: (customer) => customer.name,
                      compareFn: (a, b) => a.id == b.id,
                      onChanged: (customer) =>
                          debugPrint("Cliente seleccionado: ${customer?.name}"),
                    );
                  },
                ),

                const SizedBox(height: 15),

                /// Dropdown de maderas
                FutureBuilder<List<Wood>>(
                  future: _woodData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownSearch<Wood>(
                      context: context,
                      label: "Selecciona una madera",
                      items: (filter, lp) => snapshot.data!,
                      selectedItem: snapshot.data!.first,
                      itemAsString: (wood) => wood.name,
                      compareFn: (a, b) => a.id == b.id,
                      onChanged: (wood) =>
                          debugPrint("Madera seleccionada: ${wood?.name}"),
                    );
                  },
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
                            title: Text(device.customerId),
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
