import 'package:flutter/material.dart';
import 'package:frontend/widgets/login_button.dart';
import 'package:frontend/widgets/password_field.dart';
import 'package:frontend/widgets/user_field.dart';
import 'package:lottie/lottie.dart';

class LoginDesktopLayout extends StatelessWidget {
  const LoginDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _userController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final color = Theme.of(context).colorScheme;

    return Scaffold( // Usa un Scaffold para manejar el diseño
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Lottie.asset(
                'assets/lottie/login_desktop.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            Expanded( // Usa Expanded aquí
              child: Container(
                color: color.surfaceContainer,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenido',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    FractionallySizedBox(
                      widthFactor: 0.7, // 70% del ancho de la pantalla
                      child: Column(
                        children: [
                          UserField(controller: _userController),
                          const SizedBox(height: 30.0),
                          PasswordField(controller: _passwordController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    LoginButton(
                      userController: _userController,
                      passwordController: _passwordController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
