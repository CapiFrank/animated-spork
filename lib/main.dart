import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/controllers/company_controller.dart';
import 'package:project_cipher/controllers/device_controller.dart';
import 'package:project_cipher/router.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, persistenceEnabled: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => auth()..checkSession()),
        ChangeNotifierProvider(create: (context) => DeviceController()),
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
      builder: (context, authController, _) {
        return MaterialApp.router(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(42, 62, 40, 1),
            ),
          ),
          routerConfig: appRouter(auth()), // Pasa el authController
        );
      },
    );
  }
}

