// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:frontend/services/auth_services.dart'; // Importa AuthService
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
  final AuthService _authService = AuthService(); // Inicializa AuthService

  Future<void> _authenticate() async {
    if (_isAuthenticating) return; // Previene múltiples clics seguidos

    _isAuthenticating = true;

    final String user = widget.userController.text.trim();
    final String password = widget.passwordController.text.trim();

    // Verificar si los campos están vacíos
    if (user.isEmpty || password.isEmpty) {
      CustomSnackBar.show(context, 'El usuario y la contraseña no pueden estar vacíos.');
      _isAuthenticating = false;
      return;
    }

    setState(() {
      _isLoading = true; // Deshabilita el botón al iniciar la autenticación
    });

    try {
      final bool isAuthenticated = await _authService.login(user, password);

      if (isAuthenticated) {
        final expirationString = await _authService.getTokenExpiration();
        final expiration = DateTime.parse(expirationString!);
        final now = DateTime.now();
        final difference = expiration.difference(now);

        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;

        debugPrint('Login successful, token expires in: $hours:$minutes:$seconds');

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        debugPrint('Error: Usuario o contraseña incorrectos');
        CustomSnackBar.show(context, 'Usuario o contraseña incorrectos');
      }
    } catch (e) {
      debugPrint('Error: No fue posible conectar al servidor. $e');
      CustomSnackBar.show(context, 'No fue posible conectar al servidor.');
    } finally {
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
      onPressed: _isLoading ? null : _authenticate, // Deshabilita el botón si está cargando
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