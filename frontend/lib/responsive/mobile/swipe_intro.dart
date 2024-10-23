import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/classes/intro_data.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildMobileBody(BuildContext context, IntroData pageData) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Animación Lottie
        Lottie.asset(pageData.lottie, width: 200, height: 200),
        
        // Título completamente centrado
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.center, // Alinea el texto en el centro
            child: Text(
              pageData.title,
              textAlign: TextAlign.center, // Centra el texto dentro del widget
              style: GoogleFonts.modak(
                textStyle: TextStyle(
                  fontSize: pageData.isLast ? 30 : 40, 
                  color: pageData.titleColor,
                ),
              ),
            ),
          ),
        ),

        
        // Descripción centrada y con un ancho del 70% de la pantalla
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7, // 70% del ancho de la pantalla
            child: Text(
              pageData.description,
              textAlign: TextAlign.center, // Centrar el texto de la descripción
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(color: pageData.subColor, fontSize: 15),
              ),
            ),
          ),
        ),
        

        // Botón y Checkbox en la última página
        if (pageData.isLast)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              // Botón estilizado
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // 60% del ancho de la pantalla
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), // Alto del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bordes redondeados
                    ),
                    backgroundColor: Colors.redAccent, // Color de fondo del botón
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    "Iniciar sesión",
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      color: Colors.white, // Color del texto en el botón
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Checkbox estilizado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: Colors.redAccent, // Color del checkbox
                    value: true, // Conectar con preferencias si es necesario
                    onChanged: (bool? value) {
                      // lógica para guardar preferencia
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      // lógica para cambiar el estado del checkbox
                    },
                    child: Text(
                      "Mostrar de nuevo",
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        color: pageData.subColor, // Color del texto del checkbox
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

      ],
    ),
  );
}
