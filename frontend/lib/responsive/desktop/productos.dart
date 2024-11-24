import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_user.dart';

class ProductosDesktop extends StatefulWidget {
  const ProductosDesktop({super.key});

  @override
  ProductosDesktopState createState() => ProductosDesktopState();
}

class ProductosDesktopState extends State<ProductosDesktop> {
  late Future<List<Product>> productos;

  @override
  void initState() {
    super.initState();
    productos = ApiServices().getAllProducts();
  }

  Future<String> _getUserName(String userId) async {
    try {
      User user = await ApiServices().getUserById(userId);
      return user.userName;
    } catch (e) {
      return 'Desconocido';
    }
  }

  void _editProduct(Product product) {
    // Implementar la lógica para editar el producto
  }

  void _deleteProduct(String productId) {
    // Implementar la lógica para borrar el producto
  }

  void _addProduct() {
    // Implementar la lógica para agregar un nuevo producto
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          const DesktopMenu(),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay productos disponibles'));
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: WidgetStateColor.resolveWith((states) => theme.primary),
                              headingTextStyle: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.bold),
                              columns: _buildColumns(),
                              rows: _buildRows(snapshot.data!, theme),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: theme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Descripción')),
      DataColumn(label: Text('Precio')),
      DataColumn(label: Text('Costo')),
      DataColumn(label: Text('Stock')),
      DataColumn(label: Text('Categoría')),
      DataColumn(label: Text('Creado')),
      DataColumn(label: Text('Creado Por')),
      DataColumn(label: Text('Actualizado')),
      DataColumn(label: Text('Actualizado Por')),
      DataColumn(label: Text('Acciones')),
    ];
  }

  List<DataRow> _buildRows(List<Product> products, ColorScheme theme) {
    return products.map((product) {
      return DataRow(
        cells: [
          DataCell(Text(product.name)),
          DataCell(Text(product.description)),
          DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
          DataCell(Text('\$${product.cost.toStringAsFixed(2)}')),
          DataCell(Text(product.stock.toString())),
          DataCell(Text(product.category.toString())),
          DataCell(Text(product.created?.toIso8601String() ?? '')),
          DataCell(
            FutureBuilder<String>(
              future: _getUserName(product.createdBy ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return Text(snapshot.data ?? 'Desconocido');
                }
              },
            ),
          ),
          DataCell(Text(product.updated?.toIso8601String() ?? '')),
          DataCell(Text(product.updatedBy ?? '')),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: theme.primary),
                  onPressed: () => _editProduct(product),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.error),
                  onPressed: () => _deleteProduct(product.idProduct),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}