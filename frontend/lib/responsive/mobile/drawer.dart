import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileDrawer extends StatefulWidget {
  const MobileDrawer({super.key});

  @override
  MobileDrawerState createState() => MobileDrawerState();
}

class MobileDrawerState extends State<MobileDrawer> {
  late Timer _timer;
  int _currentImageIndex = 0;
  final AuthService _authService = AuthService();

  final List<String> images = [
    'assets/lottie/a.json',
    'assets/lottie/b.json',
    'assets/lottie/c.json',
    'assets/lottie/d.json',
    'assets/lottie/e.json',
    'assets/lottie/f.json',
    'assets/lottie/g.json',
    'assets/lottie/h.json',
    'assets/lottie/i.json',
    'assets/lottie/j.json'
  ];

  @override
  void initState() {
    super.initState();
    images.shuffle();
    _startImageTimer();
  }

  void _startImageTimer() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      ApiServices().cleanCache();
      if (mounted){
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Center(
              child: Lottie.asset(images[_currentImageIndex], width: 200, height: 200),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Stock Master',
              style: GoogleFonts.patrickHand(
                textStyle: TextStyle(
                  fontSize: 40,
                  color: theme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: theme.primary),
                  title: Text('Pedidos', style: TextStyle(color: theme.onSurface)),
                  onTap: () {
                    Navigator.pushNamed(context, '/ordenes');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.store_mall_directory, color: theme.primary),
                  title: Text('Productos', style: TextStyle(color: theme.onSurface)),
                  onTap: () {
                    Navigator.pushNamed(context, '/productos');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.supervised_user_circle, color: theme.primary),
                  title: Text('Clientes', style: TextStyle(color: theme.onSurface)),
                  onTap: () {
                    Navigator.pushNamed(context, '/clientes');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_pin_rounded, color: theme.primary),
                  title: Text('Empleados', style: TextStyle(color: theme.onSurface)),
                  onTap: () {
                    Navigator.pushNamed(context, '/empleados');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.business_sharp, color: theme.primary),
                  title: Text('Proveedores', style: TextStyle(color: theme.onSurface)),
                  onTap: () {
                    Navigator.pushNamed(context, '/proveedores');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: theme.primary),
                  title: Text('Configuración', style: TextStyle(color: theme.onSurface)),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: theme.primary),
            title: Text('Cerrar Sesión', style: TextStyle(color: theme.onSurface)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}