import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/widgets/email_field.dart';
import 'package:frontend/widgets/password_field.dart';
import 'package:frontend/widgets/login_button.dart';

class LoginMobileLayout extends StatelessWidget {
  const LoginMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/login_phone.json',
            width: 400,
            height: 300,
            fit: BoxFit.contain,
          ),
          Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 50.0),
          const Center(
            child: FractionallySizedBox(
              widthFactor: 0.7, // 70% del ancho de la pantalla
              child: Column(
                children: [
                  UserField(),
                  SizedBox(height: 30.0),
                  PasswordField(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60.0),
          const LoginButton(),
        ],
      ),
    );
  }
}