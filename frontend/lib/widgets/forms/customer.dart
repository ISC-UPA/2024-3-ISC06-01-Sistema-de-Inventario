import 'package:flutter/material.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showCustomerDialog(BuildContext context, {Customer? customer}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId') ?? '';

  final nameController = TextEditingController(text: customer?.name ?? '');
  final emailController = TextEditingController(text: customer?.email ?? '');

  bool _isLoading = false;

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
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : () {
                  if (context.mounted) {
                    Navigator.of(context).pop(null);
                  }
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  setState(() {
                    _isLoading = true;
                  });

                  final name = nameController.text;
                  final email = emailController.text;

                  try {
                    if (customer == null) {
                      final newCustomer = {
                        'Name': name,
                        'Email': email,
                        'CreatedBy': userId,
                      };
                      await ApiServices().createCustomer(newCustomer);
                      CustomSnackBar.show(context, 'Cliente creado exitosamente');
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      final updatedCustomer = {
                        'IdCustomer': customer.idCustomer,
                        'Name': name,
                        'Email': email,
                        'Created': customer.created, // Preservar el campo created
                        'CreatedBy': customer.createdBy, // Preservar el campo createdBy
                        'UpdatedBy': userId,
                      };
                      await ApiServices().updateCustomer(customer.idCustomer, updatedCustomer);
                      CustomSnackBar.show(context, 'Cliente actualizado exitosamente');
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    print(e);
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String customerId) async {
  bool _isLoading = false;

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
                onPressed: _isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  setState(() {
                    _isLoading = true;
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
                    _isLoading = false;
                  });
                },
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    },
  );
}