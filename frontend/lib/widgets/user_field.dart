import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
  final TextEditingController controller;

  const UserField({super.key, required this.controller}); // Añadir el controlador como parámetro

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return TextField(
      controller: controller, // Asignar el controlador
      style: TextStyle(color: color.primary),
      decoration: InputDecoration(
        fillColor: color.primaryContainer,
        filled: true,
        floatingLabelStyle: TextStyle(color:  color.onSecondaryContainer),
        labelText: 'Usuario',
        labelStyle: TextStyle(color: color.onSecondaryContainer),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color.primary),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
