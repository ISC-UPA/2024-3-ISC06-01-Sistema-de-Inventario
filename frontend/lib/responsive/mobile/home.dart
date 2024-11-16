import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STOCK MASTER'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      drawer: const MobileDrawer(),
      body: const Center(child: Text('Home')),
    );
  }
}
