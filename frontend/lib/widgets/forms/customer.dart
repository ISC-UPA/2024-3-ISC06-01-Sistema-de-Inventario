// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showCustomerDialog(BuildContext context, {Customer? customer}) async {
  final AuthService authService = AuthService();
  final userId = await authService.getUserData().then((value) => value?.idUser);

  final nameController = TextEditingController(text: customer?.name ?? '');
  final emailController = TextEditingController(text: customer?.email ?? '');

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
            title: Text(customer == null ? 'Agregar Cliente' : 'Editar Cliente'),
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
                            return 'Por favor ingrese el nombre';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor ingrese un email válido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  final name = nameController.text;
                  final email = emailController.text;

                  try {
                    if (customer == null) {
                      final newCustomer = {
                        'customer': {
                          'name': name,
                          'email': email,
                        },
                        'id': userId,
                      };
                      await ApiServices().createCustomer(newCustomer);
                      CustomSnackBar.show(context, 'Cliente creado exitosamente');
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      final updatedCustomer = {
                          'customer': {
                            'idCustomer': customer.idCustomer,
                            'name': name,
                            'email': email,
                            //'created': customer.created?.toIso8601String(),
                            //'createdBy': customer.createdBy,
                            'updated': DateTime.now().toIso8601String(),
                          },
                          'id': userId,
                        };
                      await ApiServices().updateCustomer(customer.idCustomer, updatedCustomer);
                      CustomSnackBar.show(context, 'Cliente actualizado exitosamente');
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

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String customerId) async {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text('¿Estás seguro de que deseas eliminar este cliente?'),
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
                    await ApiServices().deleteCustomer(customerId);
                    CustomSnackBar.show(context, 'Cliente eliminado exitosamente');
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