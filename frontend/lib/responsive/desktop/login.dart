import 'package:flutter/material.dart';
import 'package:frontend/widgets/login_button.dart';
import 'package:frontend/widgets/password_field.dart';
import 'package:frontend/widgets/user_field.dart';
import 'package:lottie/lottie.dart';

class LoginDesktopLayout extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController passwordController;

  const LoginDesktopLayout({
    super.key,
    required this.userController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Lottie.asset(
                'assets/lottie/login_desktop.json',
                width: 800,
                height: 800,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
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
                      widthFactor: 0.7,
                      child: Column(
                        children: [
                          UserField(controller: userController),
                          const SizedBox(height: 30.0),
                          PasswordField(controller: passwordController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    LoginButton(
                      userController: userController,
                      passwordController: passwordController,
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
