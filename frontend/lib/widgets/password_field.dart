import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller; // Añadir el controlador como parámetro

  const PasswordField({super.key, required this.controller}); // Constructor modificado

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller, // Asignar el controlador
      style: TextStyle(color: color.primary),
      decoration: InputDecoration(
        fillColor: color.primaryContainer,
        filled: true,
        floatingLabelStyle: TextStyle(color:  color.onSecondaryContainer),
        labelText: 'Contraseña',
        labelStyle: TextStyle(color:  color.onSecondaryContainer),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color.primary),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: color.primary,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      obscureText: _obscureText,
    );
  }
}
