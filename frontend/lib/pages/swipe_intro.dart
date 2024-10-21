import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/classes/intro_data.dart';

class SwipeIntroPage extends StatelessWidget {
  const SwipeIntroPage({super.key});

  // Cargar los datos desde el archivo JSON
  Future<List<IntroData>> _loadPagesData() async {
    final String response = await rootBundle.loadString('assets/intro_data/intro.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => IntroData.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<IntroData>>(
      future: _loadPagesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // Crear las páginas utilizando los datos del JSON
        final pages = snapshot.data!.map((pageData) {
          return _buildPage(context, pageData);
        }).toList();

        return LiquidSwipe(
          pages: pages,
          fullTransitionValue: 300,
          enableLoop: true,
          positionSlideIcon: 0.7,
          waveType: WaveType.circularReveal,
        );
      },
    );
  }

  // Construir cada página con su contenido
  Widget _buildPage(BuildContext context, IntroData pageData) {
    final Color bgColor = pageData.color;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animación Lottie
          Lottie.asset(pageData.lottie, width: 200, height: 200),
          
          // Título
          Text(
            pageData.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white) ?? 
                   const TextStyle(fontSize: 24, color: Colors.white), // Estilo por defecto si headlineMedium es null
          ),
          
          // Descripción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pageData.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          
          // Botón y Checkbox en la última página
          if (pageData.isLast)
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text("Iniciar sesión"),
                ),
                CheckboxListTile(
                  title: const Text("Mostrar de nuevo", style: TextStyle(color: Colors.white)),
                  value: true, // Aquí puedes conectar esto a preferencias con SharedPreferences
                  onChanged: (bool? value) {
                    // lógica para guardar preferencia
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}