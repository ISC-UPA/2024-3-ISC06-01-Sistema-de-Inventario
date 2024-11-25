import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/productos.dart';
import 'package:frontend/responsive/mobile/productos.dart';
import 'package:frontend/responsive/responsive_layout.dart';

class ProductosPage extends StatefulWidget {

  const ProductosPage({super.key});

  @override
  ProductosPageState createState() => ProductosPageState();
}

class ProductosPageState extends State<ProductosPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: ProductosMobile(),
        desktopBody: ProductosDesktop(),
      ),
    );
  }
}
