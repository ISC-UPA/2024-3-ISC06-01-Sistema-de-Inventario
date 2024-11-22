import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/clientes.dart';
import 'package:frontend/responsive/mobile/clientes.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  ClientesPageState createState() => ClientesPageState();
}

class ClientesPageState extends State<ClientesPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: ClientesMobile(),
        desktopBody: ClientesDesktop(),
      ),
    );
  }
}
