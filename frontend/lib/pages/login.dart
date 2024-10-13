import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/login.dart';
import 'package:frontend/responsive/mobile/login.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: LoginMobileLayout(),
        desktopBody: LoginDesktopLayout(),
      )
    );
  }
}