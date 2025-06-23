import 'package:flutter/material.dart';

class Palette {
  final BuildContext context;
  Palette(this.context);
  Color get error => Theme.of(context).colorScheme.error;
  Color get outline => Theme.of(context).colorScheme.outline;
  Color get outlineVariant => Theme.of(context).colorScheme.outlineVariant;
  Color get errorContainer => Theme.of(context).colorScheme.errorContainer;
  Color get primary => Theme.of(context).colorScheme.primary;
  Color get secondary => Theme.of(context).colorScheme.secondary;
  Color get tertiary => Theme.of(context).colorScheme.tertiary;
  Color get surface => Theme.of(context).colorScheme.surface;
  Color get shadow => Theme.of(context).colorScheme.shadow;
  Color get onError => Theme.of(context).colorScheme.onError;
  Color get onPrimary => Theme.of(context).colorScheme.onPrimary;
  Color get onSecondary => Theme.of(context).colorScheme.onSecondary;
  Color get onTertiary => Theme.of(context).colorScheme.onTertiary;
  Color get onSurface => Theme.of(context).colorScheme.onSurface;

  // Colores custom
  // Color get customGray => const Color(0xFF424242);
}
