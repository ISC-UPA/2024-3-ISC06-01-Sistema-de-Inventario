import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController userController; // Añadir controlador de usuario
  final TextEditingController passwordController; // Añadir controlador de contraseña

  const LoginButton({
    super.key,
    required this.userController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: () {
        // Imprimir los valores de usuario y contraseña
        print('Usuario: ${userController.text}');
        print('Contraseña: ${passwordController.text}');
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: color.onPrimaryContainer,
        elevation: 5,
      ),
      child: Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 18, color: color.onInverseSurface),
      ),
    );
  }
}
