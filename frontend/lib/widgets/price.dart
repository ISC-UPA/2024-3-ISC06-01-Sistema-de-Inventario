import 'package:flutter/material.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/services/api_services.dart';

class Price extends StatelessWidget {
  final RestockOrder restockOrder;
  final ApiServices apiServices;
  final TextStyle? textStyle;
  final int s;

  const Price({
    super.key,
    required this.restockOrder,
    required this.apiServices,
    required this.s,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: restockOrder.calculateTotalAmount(apiServices.getProductById, s:s),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('...', style: textStyle);
        } else if (snapshot.hasError) {
          return Text('Error', style: textStyle);
        } else {
          final totalAmount = snapshot.data ?? restockOrder.totalAmount;
          return Text(totalAmount.toStringAsFixed(2), style: textStyle);
        }
      },
    );
  }
}