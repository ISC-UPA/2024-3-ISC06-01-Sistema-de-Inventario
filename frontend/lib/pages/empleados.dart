import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/empleados.dart';
import 'package:frontend/responsive/mobile/empleados.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class EmpleadosPage extends StatefulWidget {
  const EmpleadosPage({super.key});

  @override
  EmpleadosPageState createState() => EmpleadosPageState();
}

class EmpleadosPageState extends State<EmpleadosPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: EmpleadosMobile(),
        desktopBody: EmpleadosDesktop(),
      ),
    );
  }
}
