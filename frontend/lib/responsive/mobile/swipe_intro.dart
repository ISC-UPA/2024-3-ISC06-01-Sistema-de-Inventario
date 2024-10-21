import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/classes/intro_data.dart';

Widget buildMobileBody(BuildContext context, IntroData pageData) {
  return Center(
    child: Column(
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