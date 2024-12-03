import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/login.dart';
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

    if (widget.pageData.isLast) {
      return LoginDesktopLayout(
        userController: TextEditingController(),
        passwordController: TextEditingController(),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animación Lottie
            Lottie.asset(widget.pageData.lottie, width: 400, height: 400),

            const SizedBox(height: 10),
            
            // Título completamente centrado
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center, // Alinea el texto en el centro
                child: Text(
                  widget.pageData.title,
                  textAlign: TextAlign.center, // Centra el texto dentro del widget
                  style: GoogleFonts.concertOne(
                    textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: widget.pageData.titleColor) ?? 
                               TextStyle(fontSize: 65, color: widget.pageData.titleColor),
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
                  widget.pageData.description,
                  textAlign: TextAlign.center, // Centrar el texto de la descripción
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(color: widget.pageData.subColor, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}