import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/proveedores.dart';
import 'package:frontend/responsive/mobile/proveedores.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class ProveedoresPage extends StatefulWidget {
  const ProveedoresPage({super.key});

  @override
  ProveedoresPageState createState() => ProveedoresPageState();
}

class ProveedoresPageState extends State<ProveedoresPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: ProveedoresMobile(),
        desktopBody: ProveedoresDesktop(),
      ),
    );
  }
}
