import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/forms/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductosMobile extends StatefulWidget {
  const ProductosMobile({super.key});

  @override
  ProductosMobileState createState() => ProductosMobileState();
}

class ProductosMobileState extends State<ProductosMobile> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchUserData();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiServices().getAllProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final AuthService authService = AuthService();
      final user = await authService.getUserData();
      setState(() {
        _user = user;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> _getUserName(String userId) async {
    try {
      User user = await ApiServices().getUserById(userId);
      return user.userName;
    } catch (e) {
      return '';
    }
  }

  void _editProduct(Product product) async {
    final updatedProduct = await showProductDialog(context, product: product);
    if (updatedProduct != null) {
      await _fetchProducts();
    }
  }

  void _deleteProduct(String productId) async {
    final shouldDelete = await showDeleteConfirmationDialog(context, productId);
    if (shouldDelete == true) {
      await _fetchProducts();
    }
  }

  void _addProduct() async {
    final newProduct = await showProductDialog(context);
    if (newProduct != null) {
      await _fetchProducts();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos',
          style: GoogleFonts.patrickHand(
            textStyle: TextStyle(
              fontSize: 30,
              color: theme.onPrimary,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      drawer: const MobileDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _products.isEmpty
                  ? const Center(child: Text('No hay productos disponibles'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateColor.resolveWith((states) => theme.primary),
                        headingTextStyle: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.bold),
                        columns: _buildColumns(),
                        rows: _buildRows(_products, theme),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: theme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = [
      const DataColumn(label: Text('Nombre')),
      const DataColumn(label: Text('Descripción')),
      const DataColumn(label: Text('Precio')),
      const DataColumn(label: Text('Costo')),
      const DataColumn(label: Text('Stock')),
      const DataColumn(label: Text('Stock Mínimo')),
      const DataColumn(label: Text('Creado')),
      const DataColumn(label: Text('Creado Por')),
      const DataColumn(label: Text('Actualizado')),
      const DataColumn(label: Text('Actualizado Por')),
    ];

    if (_user?.role == 0) {
      columns.add(const DataColumn(label: Text('Acciones')));
    }

    return columns;
  }

  List<DataRow> _buildRows(List<Product> products, ColorScheme theme) {
    return products.map((product) {
      final cells = [
        DataCell(Text(product.name)),
        DataCell(Text(product.description)),
        DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
        DataCell(Text('\$${product.cost.toStringAsFixed(2)}')),
        DataCell(Text(product.stock.toString())),
        DataCell(Text(product.minStock.toString())),
        DataCell(Text(_formatDate(product.created))),
        DataCell(Text(product.createdByUser?.userDisplayName ?? '')),
        DataCell(Text(_formatDate(product.updated))),
        DataCell(Text(product.updatedByUser?.userDisplayName ?? '')),
      ];

      if (_user?.role == 0) {
        cells.add(
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
        );
      }

      return DataRow(cells: cells);
    }).toList();
  }
}