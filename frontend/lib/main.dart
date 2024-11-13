import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/intro.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/swipe_intro.dart';
import 'package:frontend/server/certificate.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Crea el tema antes de ejecutar runApp()
  final themeNotifier = AppThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(MyApp(themeNotifier: themeNotifier));
}

class MyApp extends StatefulWidget {
  final AppThemeNotifier themeNotifier;

  const MyApp({super.key, required this.themeNotifier});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Future<bool> _seenTutorialFuture;

  @override
  void initState() {
    super.initState();
    _seenTutorialFuture = _checkIfFirstTime();
  }

  Future<bool> _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenTutorial') ?? true; // Retorna el valor.
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = widget.themeNotifier;

    return ChangeNotifierProvider.value(
      value: themeNotifier,
      child: Consumer<AppThemeNotifier>(
        builder: (context, tema, _) {
          return FutureBuilder<bool>(
            future: _seenTutorialFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras esperas.
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Manejo de error, podrías mostrar un mensaje o redirigir.
                return const Center(child: Text('Error loading tutorial state.'));
              } else {
                // Aquí ya tienes el valor de seenTutorial.
                bool seenTutorial = snapshot.data ?? true;
                String route = seenTutorial ? '/swipe_intro' : '/login';

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: tema.appTheme.getTheme(),
                  initialRoute: route,
                  routes: {
                    '/home': (context) => HomePage(themeNotifier: tema),
                    '/splash': (context) => const SplashScreen(),
                    '/login': (context) => const LoginPage(),
                    '/swipe_intro': (context) => const SwipeIntroPage(),
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
