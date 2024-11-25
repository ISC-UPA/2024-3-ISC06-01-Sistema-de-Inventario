import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/classes/intro_data.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopIntro extends StatefulWidget {
  final IntroData pageData;

  const DesktopIntro(this.pageData, {super.key});

  @override
  DesktopIntroState createState() => DesktopIntroState();
}

class DesktopIntroState extends State<DesktopIntro> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación Lottie
            Lottie.asset(widget.pageData.lottie, width: 200, height: 200),
            
            // Título
            Text(
              widget.pageData.title,
              style: GoogleFonts.modak(
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: widget.pageData.titleColor) ?? 
                           TextStyle(fontSize: 24, color: widget.pageData.titleColor), // Estilo por defecto si headlineMedium es null
              ),
            ),
            
            // Descripción
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.pageData.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(color: widget.pageData.subColor),
                ),
              ),
            ),
            
            // Botón y Checkbox en la última página
            if (widget.pageData.isLast)
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Alto del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bordes redondeados
                      ),
                      backgroundColor: Colors.redAccent, // Color de fondo del botón
                    ),
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Llevame ahí",
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        color: Colors.white, // Color del texto en el botón
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}