import 'package:flutter/material.dart';
import 'package:project_cipher/controllers/round_trunk_controller.dart';
import 'package:project_cipher/models/round_trunk.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/utils/volume_calculator.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/components/secondary_button.dart';

class EditRoundTrunkModal extends StatefulWidget {
  final RoundTrunk roundTrunk;
  final Sawed sawed;
  final VoidCallback onSuccess;

  const EditRoundTrunkModal({
    super.key,
    required this.sawed,
    required this.roundTrunk,
    required this.onSuccess,
  });

  @override
  State<EditRoundTrunkModal> createState() => _EditRoundTrunkModalState();
}

class _EditRoundTrunkModalState extends State<EditRoundTrunkModal> {
  final RoundTrunkController _controller = RoundTrunkController();

  late TextEditingController _circumferenceController;
  late TextEditingController _lengthController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _circumferenceController =
        TextEditingController(text: widget.roundTrunk.circumference.toString());
    _lengthController =
        TextEditingController(text: widget.roundTrunk.length.toString());
    _priceController =
        TextEditingController(text: widget.roundTrunk.price.toString());
    _circumferenceController.addListener(_updatePrice);
    _lengthController.addListener(_updatePrice);
  }

  void _updatePrice() async {
    final circumference = double.tryParse(_circumferenceController.text);
    final length = double.tryParse(_lengthController.text);

    if (circumference != null && length != null) {
      final volume = VolumeCalculator.calculateRoundLogVolume(
          circumference: circumference, length: length);
      var wood = await auth().company!.woods().find(widget.sawed.woodId);

      _priceController.text = wood!.price(volume: volume).toString();
    }
  }

  @override
  void dispose() {
    _circumferenceController.removeListener(_updatePrice);
    _lengthController.removeListener(_updatePrice);
    _circumferenceController.dispose();
    _lengthController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_circumferenceController.text.isEmpty ||
        _lengthController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ErrorHandler.handleError('Debe llenar todos los campos');
      return;
    }

    try {
      await _controller.update(
          sawed: widget.sawed,
          id: widget.roundTrunk.id!,
          circumference: double.parse(_circumferenceController.text),
          length: double.parse(_lengthController.text),
          price: double.parse(_priceController.text));
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
                "Editar Tronco",
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
                textEditingController: _circumferenceController,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                labelText: "Circunferencia",
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
                textEditingController: _lengthController,
                labelText: "Largo",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El campo no puede estar vacío";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InputText(
                textInputAction: TextInputAction.send,
                cursorColor: Palette(context).secondary,
                style: TextStyle(color: Palette(context).secondary),
                decoration: customDecoration(context),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                textEditingController: _priceController,
                labelText: "Precio",
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
