import 'package:flutter/material.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Sistema de Inventario con Autenticación y Reportes de Actividad vía Correo Electrónico'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Integrantes del equipo:"),
            SizedBox(height: 30),
            Text("Daniel Eduardo Pedroza Rodríguez"),
            SizedBox(height: 10),
            Text("KEVIN JAVIER MEDINA HERNANDEZ"),
            SizedBox(height: 10),
            Text("Nico Emmanuel Quintanilla Navarro"),
            SizedBox(height: 10),
            Text("Lenin Gerardo Silva Sabas"),
          ],
        ),
      ),
    );
  }
}
