import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/dropdown_search.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/components/slidable_button.dart';
import 'package:provider/provider.dart';
import '../controllers/device_controller.dart';
import '../models/device.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  DeviceViewState createState() => DeviceViewState();
}

class DeviceViewState extends State<DeviceView> {
  late Future<List<Device>> _data;
  final DeviceController _deviceController = DeviceController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  // void _checkAuth() async {
  //   try {
  //     final authController =
  //         Provider.of<AuthController>(context, listen: false);
  //     await authController.checkSession();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  void _logout() async {
    await Provider.of<AuthController>(context, listen: false).logout();
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
                      DropdownSearch<Device>(
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
                      DropdownSearch<Device>(
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

