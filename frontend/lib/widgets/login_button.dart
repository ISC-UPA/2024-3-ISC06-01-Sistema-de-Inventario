import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dartdap/dartdap.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.userController,
    required this.passwordController,
  });

  Future<void> _authenticate(BuildContext context) async {
    const String ldapServer = "programines.com";
    const String domain = "PROGRAMINES";
    final String user = userController.text.trim();
    final String password = passwordController.text.trim();

    final LdapConnection ldap = LdapConnection(
      host: ldapServer,
      port: 389,
      ssl: false,
    );

    try {
      await ldap.open();
      await ldap.bind(DN: "$domain\\$user", password: password); // Usar el formato adecuado para el DN
      
      Navigator.pushReplacementNamed(context, '/home'); // Navegar a la página de inicio
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    } finally {
      await ldap.close(); // Cerrar la conexión
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: () => _authenticate(context),
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
