import 'package:flutter/material.dart';
import '../controllers/company_controller.dart';
import '../models/company.dart';

class CompanyView extends StatefulWidget {
  const CompanyView({super.key});

  @override
  CompanyViewState createState() => CompanyViewState();
}

class CompanyViewState extends State<CompanyView> {
  late Future<List<Company>> _data;
  final CompanyController _companyController = CompanyController();

  @override
  void initState() {
    super.initState();
    _data = _companyController.index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company'),
      ),
      body: FutureBuilder<List<Company>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
