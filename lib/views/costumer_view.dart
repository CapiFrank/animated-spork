import 'package:flutter/material.dart';
import '../controllers/costumer_controller.dart';
import '../models/costumer.dart';

class CostumerView extends StatefulWidget {
  const CostumerView({super.key});

  @override
  _CostumerViewState createState() => _CostumerViewState();
}

class _CostumerViewState extends State<CostumerView> {
  late Future<List<Costumer>> _data;
  final CostumerController _costumerController = CostumerController();

  @override
  void initState() {
    super.initState();
    _data = _costumerController.index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Costumer'),
      ),
      body: FutureBuilder<List<Costumer>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("⚠️ Error: ${snapshot.error}");
            return Center(
                child: Text(
                    'Error: ${snapshot.error?.toString() ?? "Desconocido"}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                );
              },
            );
          } else {
            return const Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
    );
  }
}
