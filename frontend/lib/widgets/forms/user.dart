// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showUserDialog(BuildContext context, {User? user}) async {
  final AuthService authService = AuthService();
  final userId = await authService.getUserData().then((value) => value?.idUser);

  final userNameController = TextEditingController(text: user?.userName ?? '');
  final userDisplayNameController = TextEditingController(text: user?.userDisplayName ?? '');
  final emailController = TextEditingController(text: user?.email ?? '');

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int selectedRole = user?.role ?? 1;

  if (!context.mounted) return null;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(user == null ? 'Agregar Empleado' : 'Editar Empleado'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: userNameController,
                        decoration: const InputDecoration(labelText: 'Nombre de Empleado'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre de Empleado';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: userDisplayNameController,
                        decoration: const InputDecoration(labelText: 'Nombre Completo'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre completo';
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<int>(
                        value: selectedRole,
                        decoration: const InputDecoration(labelText: 'Rol'),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Administrador')),
                          DropdownMenuItem(value: 1, child: Text('Empleado')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value ?? 1;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor seleccione un rol';
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
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      isLoading = true;
                    });

                    final userName = userNameController.text;
                    final userDisplayName = userDisplayNameController.text;
                    final email = emailController.text;
                    final role = selectedRole;
                    debugPrint('Role: $role');
                    debugPrint('User: $userId');

                    try {
                      if (user == null) {
                        final newUser = {
                          'User': {
                            'UserName': userName,
                            'UserDisplayName': userDisplayName,
                            'Role': role,
                            'Email': email,
                          },
                          'Id': userId,
                        };
                        await ApiServices().createUser(newUser);
                        CustomSnackBar.show(context, 'Empleado creado exitosamente');
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      } else {
                        final updatedUser = {
                          'User': {
                            'idUser': user.idUser,
                            'userName': userName,
                            'userDisplayName': userDisplayName,
                            'role': role,
                            'email': email,
                          },
                          'Id': userId,
                        };
                        await ApiServices().updateUser(user.idUser, updatedUser);
                        CustomSnackBar.show(context, 'Empleado actualizado exitosamente');
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

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String userId) async {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text('¿Estás seguro de que deseas eliminar este Empleado?'),
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
                    await ApiServices().deleteUser(userId);
                    CustomSnackBar.show(context, 'Empleado eliminado exitosamente');
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