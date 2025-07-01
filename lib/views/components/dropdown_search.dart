import 'package:dropdown_search/dropdown_search.dart' as ds;
import 'package:flutter/material.dart';
import 'package:project_cipher/utils/palette.dart';

class DropdownSearch<T> extends StatelessWidget {
  final List<T> Function(String? filter, ds.LoadProps? lp) items;
  final T? selectedItem;
  final String Function(T item) itemAsString;
  final bool Function(T a, T b) compareFn;
  final void Function(T?) onChanged;
  final String label;
  final BuildContext context;
  final bool isEnabled;
  final InputDecoration? decoration;
  final Color? color;

  const DropdownSearch({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemAsString,
    required this.compareFn,
    required this.onChanged,
    required this.label,
    required this.context,
    this.decoration,
    this.color,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isEnabled,
      child: ds.DropdownSearch<T>(
        popupProps: ds.PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: ds.TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Buscar...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            ),
          ),
          menuProps: ds.MenuProps(
            backgroundColor: Palette(context).onSecondary,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
        ),
        items: items,
        selectedItem: selectedItem,
        itemAsString: itemAsString,
        compareFn: compareFn,
        onChanged: onChanged,
        decoratorProps: ds.DropDownDecoratorProps(
          baseStyle: TextStyle(
            color: color ?? Palette(context).onSecondary,
            fontSize: 16,
          ),
          decoration: decoration?.copyWith(labelText: label) ??
              defaultDecoration(context, label),
        ),
      ),
    );
  }
}

InputDecoration defaultDecoration(BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: Palette(context).onSecondary),
    suffixIconColor: Palette(context).onSecondary,
    fillColor: Palette(context).secondary,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).outline),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).errorContainer),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).error),
    ),
  );
}
