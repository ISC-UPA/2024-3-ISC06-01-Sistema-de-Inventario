import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
  const UserField({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary; // Color primario del tema

    return TextField(
      style: TextStyle(color: color), // Cambiar el color del texto aquí
      decoration: InputDecoration(
        labelText: 'Usuario',
        labelStyle: TextStyle(color: color), // Color de la etiqueta
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color), // Color del borde al enfocar
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
