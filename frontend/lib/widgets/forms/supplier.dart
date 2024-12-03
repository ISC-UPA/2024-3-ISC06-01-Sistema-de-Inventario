// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:frontend/models/model_supplier.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showSupplierDialog(BuildContext context, {Supplier? supplier}) async {
  final AuthService authService = AuthService();
  final userId = await authService.getUserData().then((value) => value?.idUser);

  final nameController = TextEditingController(text: supplier?.name ?? '');
  final descriptionController = TextEditingController(text: supplier?.description ?? '');

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  if (!context.mounted) return null;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(supplier == null ? 'Agregar Proveedor' : 'Editar Proveedor'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre del proveedor';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                            return 'El nombre solo puede contener letras, números y espacios';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Descripción'),
                        maxLength: 100,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la descripción del proveedor';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                            return 'La descripción solo puede contener letras, números y espacios';
                          }
                          return null;
                        },
                      ),
                    ),                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  if (context.mounted) {
                    Navigator.of(context).pop(null);
                  }
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      isLoading = true;
                    });

                    final name = nameController.text;
                    final description = descriptionController.text;

                    try {
                      if (supplier == null) {
                        final newSupplier = {
                          'supplier': {
                            'name': name,
                            'description': description,
                            'supplierStatus': 1,
                          },
                          'id': userId,
                        };
                        await ApiServices().createSupplier(newSupplier);
                        CustomSnackBar.show(context, 'Proveedor creado exitosamente');
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      } else {
                        final updatedSupplier = {
                          'supplier': {
                            'idSupplier': supplier.idSupplier,
                            'name': name,
                            'description': description,
                          },
                          'id': userId,
                        };
                        await ApiServices().updateSupplier(supplier.idSupplier, updatedSupplier);
                        CustomSnackBar.show(context, 'Proveedor actualizado exitosamente');
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      }
                    } catch (e) {
                      CustomSnackBar.show(context, 'Error: ${e.toString()}');
                      debugPrint(e.toString());
                      if (context.mounted) {
                        Navigator.of(context).pop(null);
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String supplierId) async {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text('¿Estás seguro de que deseas eliminar este proveedor?'),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await ApiServices().deleteSupplier(supplierId);
                    CustomSnackBar.show(context, 'Proveedor eliminado exitosamente');
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  }

                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    },
  );
}