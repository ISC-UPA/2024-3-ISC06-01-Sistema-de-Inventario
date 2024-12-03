import 'package:flutter/material.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/widgets/tickets/bar_code_widget.dart';

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
      future: restockOrder.calculateTotalAmount(apiServices.getProductById, s: s),
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

class TotalPrice extends StatelessWidget {
  final List<RestockOrder>? restockOrders;
  final ApiServices apiServices;
  final TextStyle? textStyle;
  final int s;
  final ColorScheme theme;

  const TotalPrice({
    super.key,
    required this.restockOrders,
    required this.apiServices,
    required this.s,
    this.textStyle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {

    if (restockOrders == null) {
      return Column(
        children: [
          ticketProductTitlesWidget('Subtotal', '', '0', theme),
          ticketProductTitlesWidget('IVA: 16%', '', '0', theme),
          ticketProductTitlesWidget('Total', '', '0', theme),
        ],
      );
    }

    return FutureBuilder<double>(
      future: _calculateTotalAmount(restockOrders!, apiServices),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              ticketProductTitlesWidget('Subtotal', '', '...', theme),
              ticketProductTitlesWidget('IVA: 16%', '', '...', theme),
              ticketProductTitlesWidget('Total', '', '...', theme),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              ticketProductTitlesWidget('Subtotal', '', 'Error', theme),
              ticketProductTitlesWidget('IVA: 16%', '', 'Error', theme),
              ticketProductTitlesWidget('Total', '', 'Error', theme),
            ],
          );
        } else {
          final totalAmount = snapshot.data ?? 0;
          return Column(
            children: [
              ticketProductTitlesWidget('Subtotal', '', totalAmount.toStringAsFixed(2), theme),
              ticketProductTitlesWidget('IVA: 16%', '', (totalAmount * .16).toStringAsFixed(2), theme),
              ticketProductTitlesWidget('Total', '', (totalAmount + (totalAmount * 0.16)).toStringAsFixed(2), theme),
            ],
          );
        }
      },
    );
  }

  Future<double> _calculateTotalAmount(List<RestockOrder> restockOrders, ApiServices apiServices) async {
    double total = 0;
    for (var restockOrder in restockOrders) {
      final amount = await restockOrder.calculateTotalAmount(apiServices.getProductById, s: s);
      total += amount;
    }
    return total;
  }
}