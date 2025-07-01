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
import 'package:project_cipher/views/partials/edit_sawed_view.dart';
import 'package:provider/provider.dart';

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
  final ValueNotifier<Customer?> selectedCustomerNotifier = ValueNotifier(null);
  final ValueNotifier<Wood?> selectedWoodNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _data = _sawedController.index();
    _customerData = _customerController.index();
    _woodData = _woodController.index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<dynamic>>(
      future: Future.wait([_data, _customerData, _woodData]),
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
          final sawedList = snapshot.data![0] as List<Sawed>;
          final customerList = snapshot.data![1] as List<Customer>;
          final woodList = snapshot.data![2] as List<Wood>;
          return ScrollLayout(
            isEmpty: sawedList.isEmpty,
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
                ValueListenableBuilder<Customer?>(
                  valueListenable: selectedCustomerNotifier,
                  builder: (context, selected, _) {
                    return DropdownSearch<Customer>(
                      context: context,
                      label: "Selecciona un cliente",
                      items: (filter, lp) => customerList,
                      selectedItem: selected,
                      itemAsString: (customer) => customer.name,
                      compareFn: (a, b) => a.id == b.id,
                      onChanged: (customer) {
                        selectedCustomerNotifier.value = customer;
                      },
                    );
                  },
                ),

                const SizedBox(height: 15),

                /// Dropdown de maderas
                ValueListenableBuilder<Wood?>(
                  valueListenable: selectedWoodNotifier,
                  builder: (context, selected, _) {
                    return DropdownSearch<Wood>(
                      context: context,
                      label: "Selecciona una madera",
                      items: (filter, lp) => woodList,
                      selectedItem: selected,
                      itemAsString: (wood) => wood.name,
                      compareFn: (a, b) => a.id == b.id,
                      onChanged: (wood) {
                        selectedWoodNotifier.value = wood;
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: SecondaryButton(
                    labelText: "Agregar",
                    onPressed: () async {
                      if (selectedCustomerNotifier.value == null ||
                          selectedWoodNotifier.value == null) {
                        ErrorHandler.handleError(
                            'Seleccioná cliente y tipo de madera');
                        return;
                      }
                      try {
                        await _sawedController.store(
                          customerId: selectedCustomerNotifier.value!.id!,
                          woodId: selectedWoodNotifier.value!.id!,
                        );
                        selectedCustomerNotifier.value = null;
                        selectedWoodNotifier.value = null;
                        // Clear selections after adding
                        setState(() {
                          _data = _sawedController.index();
                        });
                      } catch (error) {
                        ErrorHandler.handleError(
                            'Error al agregar el aserrado: $error');
                      }
                    },
                  ),
                ),
              ],
            ),
            bodyChild: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final device = sawedList[index];

                  final customerName = customerList
                      .firstWhere((c) => c.id == device.customerId,
                          orElse: () =>
                              Customer(name: 'Desconocido', phoneNumber: ''))
                      .name;

                  final woodName = woodList
                      .firstWhere((w) => w.id == device.woodId,
                          orElse: () => Wood(
                              name: 'Desconocida',
                              pricePerInch: 0,
                              discount: 0))
                      .name;
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Slidable(
                        key: ValueKey(device.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Palette(context).surface,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => EditSawedModal(
                                    sawed: device,
                                    customerList: customerList,
                                    woodList: woodList,
                                    onSuccess: () {
                                      setState(() {
                                        _data = _sawedController.index();
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
                              onPressed: () => _sawedController
                                  .destroy(
                                id: device.id!,
                              )
                                  .then((_) {
                                setState(() {
                                  _data = _sawedController.index();
                                });
                              }).catchError((error) {
                                ErrorHandler.handleError(
                                    'Error al eliminar el aserrado: $error');
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
                            title: Text(customerName),
                            subtitle: Text(woodName),
                          ),
                        ),
                      ));
                },
                childCount: sawedList.length,
              ),
            ),
          );
        }
      },
    ));
  }
}
