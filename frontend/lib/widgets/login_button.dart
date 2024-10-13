import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dartdap/dartdap.dart';
import 'package:frontend/widgets/snake_bar.dart';

class LoginButton extends StatefulWidget {
  final TextEditingController userController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.userController,
    required this.passwordController,
  });

  @override
  LoginButtonState createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {
  bool _isLoading = false;
  bool _isAuthenticating = false;

  Future<void> _authenticate(BuildContext context) async {
    if (_isAuthenticating) return; // Previene múltiples clics seguidos

    _isAuthenticating = true;

    const String ldapServer = "programines.com";
    const String domain = "PROGRAMINES";
    final String user = widget.userController.text.trim();
    final String password = widget.passwordController.text.trim();

    final LdapConnection ldap = LdapConnection(
      host: ldapServer,
      port: 389,
      ssl: false,
    );

    setState(() {
      _isLoading = true; // Deshabilita el botón al iniciar la autenticación
    });

    try {
      await ldap.open();
      await ldap.bind(DN: "$domain\\$user", password: password);
      Navigator.pushReplacementNamed(context, '/home');
    } on LdapSocketException catch (_) {
      CustomSnackBar.show(context, 'El servidor negó la conexión.');
    } on LdapResultException catch (_) {
      CustomSnackBar.show(context, 'Usuario o contraseña incorrectos');
    } catch (e) {
      CustomSnackBar.show(context, 'No fue posible conectar al servidor.');
    } finally {
      await ldap.close();
      setState(() {
        _isLoading = false; // Rehabilita el botón después de la autenticación
        _isAuthenticating = false; // Permite otra autenticación después
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: _isLoading ? null : () => _authenticate(context), // Deshabilita el botón si está cargando
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: color.onPrimaryContainer,
        elevation: 5,
      ),
      child: _isLoading
          ? const CircularProgressIndicator() // Muestra un indicador de carga
          : Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 18, color: color.onInverseSurface),
            ),
    );
  }
}
