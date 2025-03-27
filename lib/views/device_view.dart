import 'package:flutter/material.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import '../controllers/device_controller.dart';
import '../models/device.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  _DeviceViewState createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late Future<List<Device>> _data;
  final DeviceController _deviceController = DeviceController();

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
      appBar: AppBar(title: const Text('Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Device>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              debugPrint("⚠️ Error: ${snapshot.error}");
              return Center(
                  child: Text(
                      'Error: ${snapshot.error?.toString() ?? "Desconocido"}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Provider.of<AuthController>(context, listen: false)
                          .logout(context);
                    }, // Recarga la lista al presionar
                    child: const Text('Actualizar'),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].name),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No hay datos disponibles.'));
            }
          },
        ),
      ),
    );
  }
}
