import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/login.dart';
import 'package:frontend/responsive/mobile/login.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: LoginMobileLayout(
          userController: _userController,
          passwordController: _passwordController,
        ),
        desktopBody: LoginDesktopLayout(
          userController: _userController,
          passwordController: _passwordController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
