import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/responsive/desktop/swipe_intro.dart';
import 'package:frontend/responsive/mobile/swipe_intro.dart';
import 'package:frontend/responsive/responsive_layout.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
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
          fullTransitionValue: 880,
          enableLoop: false,
          positionSlideIcon: 0.8,
          waveType: WaveType.liquidReveal,
          slideIconWidget: const Icon(Icons.arrow_back_ios),
          enableSideReveal: true,
          ignoreUserGestureWhileAnimating: true,
          preferDragFromRevealedArea: true,
        );
      },
    );
  }

  // Construir cada página con su contenido
  Widget _buildPage(BuildContext context, IntroData pageData) {
    final Color bgColor = pageData.color;

    return Scaffold(
      backgroundColor: bgColor,
      body: ResponsiveLayout(
        mobileBody: buildMobileBody(context, pageData),
        desktopBody: buildDesktopBody(context, pageData),
      ),
    );
  }
}