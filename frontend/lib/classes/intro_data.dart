import 'package:flutter/material.dart';

class IntroData {
  final String title;
  final String lottie;
  final String description;
  final bool isLast;
  final Color color;
  final Color titleColor;
  final Color subColor; 

  IntroData({
    required this.title,
    required this.lottie,
    required this.description,
    this.isLast = false,
    required String color,
    required String titleColor,
    required String subColor, 
  })  : color = _parseColor(color),
        titleColor = _parseColor(titleColor),
        subColor = _parseColor(subColor);

  factory IntroData.fromJson(Map<String, dynamic> json) {
    return IntroData(
      title: json['title'],
      lottie: json['image'],
      description: json['description'],
      isLast: json['isLast'] ?? false,
      color: json['color'] ?? '#FFFFFF',
      titleColor: json['titleColor'] ?? '#000000',
      subColor: json['subColor'] ?? '#000000',
    );
  }

  // Método para convertir el string en un Color
  static Color _parseColor(String color) {
    color = color.replaceAll('#', '');
    return Color(int.parse('0xFF$color'));
  }
}
