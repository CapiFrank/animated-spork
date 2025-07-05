import 'package:flutter/material.dart';
import 'package:project_cipher/controllers/sawed_controller.dart';
import 'package:project_cipher/models/customer.dart';
import 'package:project_cipher/models/sawed.dart';
import 'package:project_cipher/models/wood.dart';
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/dropdown_search.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/components/secondary_button.dart';

class EditSawedModal extends StatefulWidget {
  final Sawed sawed;
  final List<Customer> customerList;
  final List<Wood> woodList;
  final VoidCallback onSuccess;

  const EditSawedModal({
    super.key,
    required this.sawed,
    required this.customerList,
    required this.woodList,
    required this.onSuccess,
  });

  @override
  State<EditSawedModal> createState() => _EditSawedModalState();
}

class _EditSawedModalState extends State<EditSawedModal> {
  final SawedController _controller = SawedController();
  final ValueNotifier<Customer?> selectedCustomerNotifier = ValueNotifier(null);
  final ValueNotifier<Wood?> selectedWoodNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    selectedCustomerNotifier.value = widget.customerList.firstWhere(
      (c) => c.id == widget.sawed.customerId,
      orElse: () => widget.customerList.first,
    );

    selectedWoodNotifier.value = widget.woodList.firstWhere(
        (w) => w.id == widget.sawed.woodId,
        orElse: () => widget.woodList.first);
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
                "Editar Aserrado",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Palette(context).secondary,
                ),
              ),
              const SizedBox(height: 15),
              ValueListenableBuilder<Customer?>(
                valueListenable: selectedCustomerNotifier,
                builder: (context, selected, _) {
                  return DropdownSearch<Customer>(
                    context: context,
                    color: Palette(context).secondary,
                    decoration: customDecoration(context),
                    label: "Cliente",
                    items: (filter, lp) => widget.customerList,
                    selectedItem: selected,
                    itemAsString: (customer) => customer.name,
                    compareFn: (a, b) => a.id == b.id,
                    onChanged: (customer) {
                      selectedCustomerNotifier.value = customer;
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              ValueListenableBuilder<Wood?>(
                valueListenable: selectedWoodNotifier,
                builder: (context, selected, _) {
                  return DropdownSearch<Wood>(
                    context: context,
                    color: Palette(context).secondary,
                    decoration: customDecoration(context),
                    label: "Madera",
                    items: (filter, lp) => widget.woodList,
                    selectedItem: selected,
                    itemAsString: (wood) => wood.name,
                    compareFn: (a, b) => a.id == b.id,
                    onChanged: (wood) {
                      selectedWoodNotifier.value = wood;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      labelText: "Guardar Cambios",
                      onPressed: () async {
                        if (selectedCustomerNotifier.value == null ||
                            selectedWoodNotifier.value == null) {
                          ErrorHandler.handleError(
                              'Seleccioná cliente y tipo de madera');
                          return;
                        }

                        try {
                          await _controller.update(
                            id: widget.sawed.id!,
                            customerId: selectedCustomerNotifier.value!.id!,
                            woodId: selectedWoodNotifier.value!.id!,
                          );
                          widget.onSuccess();
                        } catch (error) {
                          ErrorHandler.handleError(
                              'Error al actualizar el aserrado: $error');
                        }
                      },
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
