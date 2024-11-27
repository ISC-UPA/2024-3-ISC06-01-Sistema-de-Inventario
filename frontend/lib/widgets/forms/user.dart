import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showUserDialog(BuildContext context, {User? user}) async {
  final AuthService authService = AuthService();
  final userId = await authService.getUserData().then((value) => value?.idUser);
  print('User ID: $userId');

  final userNameController = TextEditingController(text: user?.userName ?? '');
  final userDisplayNameController = TextEditingController(text: user?.userDisplayName ?? '');
  final emailController = TextEditingController(text: user?.email ?? '');
  final roleController = TextEditingController(text: user?.role.toString() ?? '');

  bool _isLoading = false;

  if (!context.mounted) return null;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(user == null ? 'Agregar Usuario' : 'Editar Usuario'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
                  ),
                  TextField(
                    controller: userDisplayNameController,
                    decoration: const InputDecoration(labelText: 'Nombre Completo'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Rol'),
                    keyboardType: TextInputType.number,
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

                  final userName = userNameController.text;
                  final userDisplayName = userDisplayNameController.text;
                  final email = emailController.text;
                  final role = int.tryParse(roleController.text) ?? 0;

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
                      CustomSnackBar.show(context, 'Usuario creado exitosamente');
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
                      CustomSnackBar.show(context, 'Usuario actualizado exitosamente');
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

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String userId) async {
  bool _isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
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
                    await ApiServices().deleteUser(userId);
                    CustomSnackBar.show(context, 'Usuario eliminado exitosamente');
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