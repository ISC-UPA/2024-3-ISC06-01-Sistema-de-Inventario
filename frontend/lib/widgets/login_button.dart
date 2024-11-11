import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
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
      final response = await http.post(
        Uri.parse('https://192.168.182.25:7113/api/Auth?Email=$user&password=$password'),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        print('Error: Usuario o contraseña incorrectos');
        CustomSnackBar.show(context, 'Usuario o contraseña incorrectos');
      }
    } catch (e) {
      print('Error: No fue posible conectar al servidor. $e');
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