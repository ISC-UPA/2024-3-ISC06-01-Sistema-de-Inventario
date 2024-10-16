import 'package:flutter/material.dart';

class IntroData {
  final String title;
  final String lottie;
  final String description;
  final bool isLast;
  final Color color; // Cambiar el tipo a Color

  IntroData({
    required this.title,
    required this.lottie,
    required this.description,
    this.isLast = false,
    required String color,
  }) : color = _parseColor(color); // Asignar el valor a color utilizando el método _parseColor

  factory IntroData.fromJson(Map<String, dynamic> json) {
    return IntroData(
      title: json['title'],
      lottie: json['image'],
      description: json['description'],
      isLast: json['isLast'] ?? false,
      color: json['color'] ?? '#FFFFFF', // Agregar color y proporcionar un valor predeterminado
    );
  }

  // Método para convertir el string en un Color
  static Color _parseColor(String color) {
    color = color.replaceAll('#', ''); // Eliminar el símbolo # si está presente
    return Color(int.parse('0xFF$color')); // Añadir el prefijo 0xFF para la opacidad
  }
}
