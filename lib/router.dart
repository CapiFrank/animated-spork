import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/utils/saw_pos_icons.dart';
import 'package:project_cipher/views/customer_view.dart';
import 'package:project_cipher/views/sawed_view.dart';
import 'package:project_cipher/views/loading_view.dart';
import 'package:project_cipher/views/login_view.dart';
import 'package:project_cipher/views/payment_blocked_view.dart';
import 'package:project_cipher/views/wood_plank_view.dart';
import 'package:project_cipher/views/wood_view.dart';
import 'package:flutter/material.dart';

GoRouter appRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/device',
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/device',
              builder: (context, state) => SawedView(),
            ),
            GoRoute(
              path: '/customer',
              builder: (context, state) => CustomerView(),
            ),
            GoRoute(
              path: '/wood',
              builder: (context, state) => WoodView(),
            ),
            GoRoute(
              path: '/wood_plank',
              builder: (context, state) => WoodPlankView(),
            ),
          ]),
      GoRoute(
        path: '/loading',
        builder: (context, state) => LoadingView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/payment-blocked',
        builder: (context, state) => PaymentBlockedView(),
      ),
    ],
    redirect: (context, state) {
      if (authController.isLoading) {
        return '/loading'; // Redirigir a la vista de carga si está cargando
      }
      if (authController.isAuthenticated && authController.isDeviceActive) {
        return null; // No hacer redirección si ya está en la ruta correcta
      }
      if (authController.isAuthenticated && !authController.isDeviceActive) {
        return '/payment-blocked'; // Si el dispositivo no está activo, va a la vista de bloqueo
      }
      if (!authController.isAuthenticated) {
        return '/login'; // Si no está autenticado, siempre va a login
      }
      return null; // No hacer redirección si ya está en la ruta correcta
    },
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  int _getSelectedIndex(String location) {
    if (location.startsWith('/wood_plank')) return 0;
    if (location.startsWith('/wood')) return 1;
    if (location.startsWith('/device')) return 2;
    if (location.startsWith('/customer')) return 3;
    if (location.startsWith('/device')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/wood_plank');
        break;
      case 1:
        context.go('/wood');
        break;
      case 2:
        context.go('/device');
        break;
      case 3:
        context.go('/customer');
        break;
      case 4:
        authController.logout();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        _getSelectedIndex(GoRouterState.of(context).uri.toString());

    return Scaffold(
      body: child,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        color: Palette(context).secondary,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        height: 50,
        items: [
          Icon(SawPos.woodPlank, color: Palette(context).surface),
          Icon(SawPos.woodLog, color: Palette(context).surface),
          Icon(SawPos.saw, color: Palette(context).surface),
          Icon(SawPos.customer, color: Palette(context).surface),
          Icon(SawPos.settings, color: Palette(context).surface),
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
