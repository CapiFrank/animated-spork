import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import '../controllers/customer_controller.dart';
import '../models/customer.dart';
import 'components/dropdown_search.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  CustomerViewState createState() => CustomerViewState();
}

class CustomerViewState extends State<CustomerView> {
  late Future<List<Customer>> _data;
  final CustomerController _costumerController = CustomerController();

  @override
  void initState() {
    super.initState();
    _data = _costumerController.index();
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
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                // expandedHeight: 200,
                toolbarHeight: 300,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shadowColor: Colors.black,
                title: Center(
                  child: Column(
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
                      DropdownSearch<Customer>(
                        context: context,
                        label: "Selecciona un cliente",
                        items: (filter, lp) => snapshot.data!,
                        selectedItem: snapshot.data!.first,
                        itemAsString: (device) => device.name,
                        compareFn: (a, b) => a.id == b.id,
                        onChanged: (device) =>
                            debugPrint("Seleccionado: ${device?.name}"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownSearch<Customer>(
                        context: context,
                        label: "Selecciona un tipo de madera",
                        items: (filter, lp) => snapshot.data!,
                        selectedItem: snapshot.data!.first,
                        itemAsString: (device) => device.name,
                        compareFn: (a, b) => a.id == b.id,
                        onChanged: (device) =>
                            debugPrint("Seleccionado: ${device?.name}"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SecondaryButton(labelText: "Agregar", onPressed: () {}),
                    ],
                  ),
                ),
              ),
              SliverList(
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
            ],
          );
        } else {
          return const Center(child: Text('No hay datos disponibles.'));
        }
      },
    ));
  }
}
