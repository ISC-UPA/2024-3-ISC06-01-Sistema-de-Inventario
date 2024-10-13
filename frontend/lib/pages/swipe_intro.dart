import 'package:flutter/material.dart';

class SwipeIntroPage extends StatelessWidget {
  const SwipeIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Swipe Intro")),
      body: Center(
        child: ElevatedButton(onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        }, child: const Text("Ir a Login"))

      ),
    );
  }
}