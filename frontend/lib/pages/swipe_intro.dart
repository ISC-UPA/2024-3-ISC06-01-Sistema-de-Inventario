import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/classes/intro_data.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';

class SwipeIntroPage extends StatelessWidget {
  const SwipeIntroPage({super.key});

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

  Widget _buildPage(BuildContext context, IntroData pageData) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: pageData.color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(pageData.lottie, width: 200, height: 200), // Aquí se muestra la animación Lottie
          Text(pageData.title, style: TextStyle(color: color.primary)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(pageData.description, textAlign: TextAlign.center),
          ),
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
                  title: const Text("Mostrar de nuevo"),
                  value: true, // puedes conectar esto a la lógica de preferencias
                  onChanged: (bool? value) {
                    // guardar el valor en preferencias si es necesario
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
