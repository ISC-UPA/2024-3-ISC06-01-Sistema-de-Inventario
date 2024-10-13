import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // Estado para ocultar la contraseña

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary; // Color primario del tema

    return TextField(
      style: TextStyle(color: color), // Cambiar el color del texto aquí
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: color), // Color de la etiqueta
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color), // Color del borde al enfocar
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off, // Icono de ojo
            color: color, // Color del icono
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Alternar el estado de visibilidad
            });
          },
        ),
      ),
      obscureText: _obscureText, // Controla la visibilidad del texto
    );
  }
}
