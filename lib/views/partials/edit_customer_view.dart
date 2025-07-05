import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_cipher/controllers/customer_controller.dart';
import 'package:project_cipher/models/customer.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/components/secondary_button.dart';

class EditCustomerModal extends StatefulWidget {
  final Customer customer;
  final VoidCallback onSuccess;

  const EditCustomerModal({
    super.key,
    required this.customer,
    required this.onSuccess,
  });

  @override
  State<EditCustomerModal> createState() => _EditCustomerModalState();
}

class _EditCustomerModalState extends State<EditCustomerModal> {
  final CustomerController _controller = CustomerController();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.customer.name);
    phoneController = TextEditingController(text: widget.customer.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ErrorHandler.handleError('Ingrese un nombre y número de telefono');
      return;
    }

    try {
      await _controller.update(
          id: widget.customer.id!,
          name: nameController.text,
          phoneNumber: phoneController.text);
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
                "Editar Cliente",
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
                textEditingController: nameController,
                labelText: "Nombre completo",
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
                    decimal: true, signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Solo acepta dígitos 0-9
                ],
                textEditingController: phoneController,
                labelText: "Número de teléfono",
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
