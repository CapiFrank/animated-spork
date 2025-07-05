import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/utils/saw_pos_icons.dart';
import 'package:project_cipher/views/customer_view.dart';
import 'package:project_cipher/views/round_trunk_view.dart';
import 'package:project_cipher/views/sawed_view.dart';
import 'package:project_cipher/views/loading_view.dart';
import 'package:project_cipher/views/login_view.dart';
import 'package:project_cipher/views/payment_blocked_view.dart';
import 'package:project_cipher/views/square_trunk_view.dart';
import 'package:project_cipher/views/wood_view.dart';
import 'package:flutter/material.dart';

GoRouter appRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/sawed',
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
                path: '/sawed',
                builder: (context, state) => SawedView(),
                routes: [
                  GoRoute(
                    path: '/square_trunk',
                    builder: (context, state) {
                      final Sawed sawed = state.extra as Sawed;
                      return SquareTrunkView(sawed: sawed);
                    },
                  ),
                  GoRoute(
                    path: '/round_trunk',
                    builder: (context, state) {
                      final Sawed sawed = state.extra as Sawed;
                      return RoundTrunkView(sawed: sawed);
                    },
                  ),
                ]),
            GoRoute(
              path: '/customer',
              builder: (context, state) => CustomerView(),
            ),
            GoRoute(
              path: '/wood',
              builder: (context, state) => WoodView(),
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

class _BottomNavBar extends StatelessWidget {
  int _getSelectedIndex(String location) {
    switch (location) {
      case '/sawed':
        return 0;
      case '/wood':
        return 1;
      case '/customer':
        return 2;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/sawed');
        break;
      case 1:
        context.go('/wood');
        break;
      case 2:
        context.go('/customer');
        break;
      case 3:
        authController.logout();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        _getSelectedIndex(GoRouterState.of(context).uri.toString());
    return CurvedNavigationBar(
      index: currentIndex,
      color: Palette(context).secondary,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      height: 50,
      items: [
        Icon(SawPos.saw, color: Palette(context).onSecondary),
        Icon(SawPos.woodPlank, color: Palette(context).onSecondary),
        Icon(SawPos.customer, color: Palette(context).onSecondary),
        Icon(SawPos.settings, color: Palette(context).onSecondary),
      ],
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}
