import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/pages/clientes.dart';
import 'package:frontend/pages/empleados.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/intro.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/ordenes.dart';
import 'package:frontend/pages/productos.dart';
import 'package:frontend/pages/proveedores.dart';
import 'package:frontend/pages/settings.dart';
import 'package:frontend/pages/swipe_intro.dart';
import 'package:frontend/services/certificate.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/auth_services.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  
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
  late Future<String> _initialRouteFuture;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture = _initializeApp();
  }

  Future<String> _initializeApp() async {
    final authService = AuthService();
    final hasUserCredentials = await authService.hasUserCredentials();
    if (!hasUserCredentials) {
      debugPrint('User credentials not found at startup.');
      return '/login';
    } else {
      debugPrint('User credentials found at startup.');
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = widget.themeNotifier;

    return ChangeNotifierProvider.value(
      value: themeNotifier,
      child: Consumer<AppThemeNotifier>(
        builder: (context, tema, _) {
          return FutureBuilder<String>(
            future: _initialRouteFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras esperas.
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Manejo de error, podrías mostrar un mensaje o redirigir.
                return const Center(child: Text('Error loading app.'));
              } else {
                // Aquí ya tienes la ruta inicial.
                String initialRoute = snapshot.data ?? '/login';

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: tema.appTheme.getTheme(),
                  initialRoute: initialRoute,
                  routes: {
                    '/': (context) => HomePage(themeNotifier: tema),
                    '/splash': (context) => const SplashScreen(),
                    '/login': (context) => const LoginPage(),
                    '/swipe_intro': (context) => const SwipeIntroPage(),
                    '/settings': (context) => SettingsPage(themeNotifier: tema),
                    '/clientes': (context) => const ClientesPage(),
                    '/proveedores': (context) => const ProveedoresPage(),
                    '/productos': (context) => const ProductosPage(),
                    '/empleados': (context) => const EmpleadosPage(),
                    '/ordenes': (context) => const OrderPage(),
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