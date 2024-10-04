import 'package:flutter/material.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIARAvCE'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sistema de Inventario con Autenticación y Reportes de Actividad vía Correo Electrónico',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueGrey),
            ),
            SizedBox(height: 30),
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
