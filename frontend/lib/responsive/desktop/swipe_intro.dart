import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/classes/intro_data.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildDesktopBody(BuildContext context, IntroData pageData) {
  return Center(
    child: Container(
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animación Lottie
          Lottie.asset(pageData.lottie, width: 200, height: 200),
          
          // Título
          Text(
            pageData.title,
            style: GoogleFonts.modak(
              textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: pageData.titleColor) ?? 
                         TextStyle(fontSize: 24, color: pageData.titleColor), // Estilo por defecto si headlineMedium es null
            ),
          ),
          
          // Descripción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pageData.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(color: pageData.subColor),
              ),
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
                  title: Text("Mostrar de nuevo", style: GoogleFonts.modak(textStyle: TextStyle(color: pageData.subColor))),
                  value: true, // Aquí puedes conectar esto a preferencias con SharedPreferences
                  onChanged: (bool? value) {
                    // lógica para guardar preferencia
                  },
                ),
              ],
            ),
        ],
      ),
    ),
  );
}