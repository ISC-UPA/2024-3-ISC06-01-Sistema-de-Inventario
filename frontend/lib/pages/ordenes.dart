import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/ordenes.dart';
import 'package:frontend/responsive/mobile/ordenes.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class OrderPage extends StatefulWidget {

  const OrderPage({super.key});

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: OrderMobile(),
        desktopBody: OrderDesktop(),
      ),
    );
  }
}
