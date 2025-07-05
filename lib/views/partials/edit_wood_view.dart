import 'package:flutter/material.dart';
import 'package:project_cipher/controllers/wood_controller.dart';
import 'package:project_cipher/models/wood.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/components/secondary_button.dart';

class EditWoodModal extends StatefulWidget {
  final Wood wood;
  final VoidCallback onSuccess;

  const EditWoodModal({
    super.key,
    required this.wood,
    required this.onSuccess,
  });

  @override
  State<EditWoodModal> createState() => _EditWoodModalState();
}

class _EditWoodModalState extends State<EditWoodModal> {
  final WoodController _controller = WoodController();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.wood.name);
    _priceController =
        TextEditingController(text: widget.wood.pricePerUnit.toString());
    _discountController =
        TextEditingController(text: widget.wood.discount.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _discountController.text.isEmpty) {
      ErrorHandler.handleError('Ingrese un nombre, un precio y un descuento');
      return;
    }

    try {
      await _controller.update(
          id: widget.wood.id!,
          name: _nameController.text,
          pricePerUnit: double.parse(_priceController.text),
          discount: double.parse(_discountController.text));
      widget.onSuccess();
    } catch (error) {
      ErrorHandler.handleError('Error al actualizar el aserrado: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Editar Madera",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Palette(context).secondary,
                ),
              ),
              const SizedBox(height: 15),
              InputText(
                textInputAction: TextInputAction.next,
                cursorColor: Palette(context).secondary,
                style: TextStyle(color: Palette(context).secondary),
                decoration: customDecoration(context),
                textEditingController: _nameController,
                labelText: "Nombre",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo no puede estar vacío";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              InputText(
                textInputAction: TextInputAction.next,
                cursorColor: Palette(context).secondary,
                style: TextStyle(color: Palette(context).secondary),
                decoration: customDecoration(context),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                textEditingController: _priceController,
                labelText: "Precio",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo no puede estar vacío";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              InputText(
                textInputAction: TextInputAction.send,
                cursorColor: Palette(context).secondary,
                style: TextStyle(color: Palette(context).secondary),
                decoration: customDecoration(context),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                textEditingController: _discountController,
                labelText: "Descuento",
                onFieldSubmitted: (_) => _onSubmit(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo no puede estar vacío";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      labelText: "Guardar Cambios",
                      onPressed: () => _onSubmit(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SecondaryButton(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                          color: Palette(context).primary,
                        ),
                      ),
                      color: Palette(context).primary,
                      labelText: "Cancelar",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration customDecoration(BuildContext context) {
  return InputDecoration(
    labelStyle: TextStyle(color: Palette(context).secondary),
    suffixIconColor: Palette(context).secondary,
    fillColor: Palette(context).onSecondary,
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
