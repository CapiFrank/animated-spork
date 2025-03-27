import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/controllers/company_controller.dart';
import 'package:project_cipher/controllers/costumer_controller.dart';
import 'package:project_cipher/controllers/device_controller.dart';
import 'package:project_cipher/views/company_view.dart';
import 'package:project_cipher/views/costumer_view.dart';
import 'package:project_cipher/views/device_view.dart';
import 'package:project_cipher/views/login_view.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => DeviceController()),
        ChangeNotifierProvider(create: (context) => CostumerController()),
        ChangeNotifierProvider(create: (context) => CompanyController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Color.fromRGBO(42, 62, 40, 1))),
          home: authController.isAuthenticated ? DeviceView() : LoginView(),
          routes: {
            '/users': (context) => CompanyView(),
            '/products': (context) => CostumerView(),
          },
        );
      },
    );
  }
}
