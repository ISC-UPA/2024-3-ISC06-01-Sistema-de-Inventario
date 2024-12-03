import 'package:flutter/material.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'dart:async';

class ProductEntradasSalidas extends StatefulWidget {
  final List<Product> products;
  final Map<String, int>? initialOrderQuantities;
  final bool isEntrada;

  const ProductEntradasSalidas({
    super.key,
    required this.products,
    this.initialOrderQuantities,
    required this.isEntrada,
  });

  @override
  ProductEntradasSalidasState createState() => ProductEntradasSalidasState();
}

class ProductEntradasSalidasState extends State<ProductEntradasSalidas> {
  List<Product> filteredProducts = [];
  Map<String, int> orderQuantities = {};
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
    orderQuantities = widget.initialOrderQuantities ?? {};
  }

  void _filterProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      setState(() {
        filteredProducts = widget.products
            .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredProducts.sort((a, b) => b.stock.compareTo(a.stock));
      });
    });
  }

  void _incrementQuantity(String productId) {
    setState(() {
      final currentQuantity = orderQuantities[productId] ?? 0;
      orderQuantities[productId] = currentQuantity + 1;
    });
  }

  void _decrementQuantity(String productId) {
    setState(() {
      final currentQuantity = orderQuantities[productId] ?? 0;
      if (currentQuantity > 0) {
        orderQuantities[productId] = currentQuantity - 1;
      }
    });
  }

  bool _canIncrement(String productId) {
    final product = widget.products.firstWhere((product) => product.idProduct == productId);
    final currentQuantity = orderQuantities[productId] ?? 0;
    return widget.isEntrada || currentQuantity < product.stock;
  }

  void _validateQuantity(String productId) {
    final product = widget.products.firstWhere((product) => product.idProduct == productId);
    final currentQuantity = orderQuantities[productId] ?? 0;

    if (!widget.isEntrada && currentQuantity > product.stock) {
      CustomSnackBar.show(context, 'No puedes sacar más de lo que hay en stock.');
    }
  }

  Future<void> _updateStock() async {
    final apiService = ApiServices();
    for (var entry in orderQuantities.entries) {
      final productId = entry.key;
      final quantity = entry.value;
      final total = widget.isEntrada ? quantity : -quantity;
      await apiService.updateProductStock(productId, total);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6, // 60% del ancho de la pantalla
        height: MediaQuery.of(context).size.height * 0.5, // 50% del alto de la pantalla
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.isEntrada ? 'Registrar Entrada' : 'Registrar Salida',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        labelText: 'Buscar producto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: theme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(
                              product.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              'Stock: ${product.stock}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _isLoading ? null : () {
                                    _decrementQuantity(product.idProduct);
                                    _validateQuantity(product.idProduct);
                                  },
                                ),
                                Text(
                                  orderQuantities[product.idProduct]?.toString() ?? '0',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _isLoading || !_canIncrement(product.idProduct) ? null : () {
                                    _incrementQuantity(product.idProduct);
                                    _validateQuantity(product.idProduct);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      Navigator.of(context).pop();
                    }, 
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _updateStock();
                      Navigator.of(context).pop({
                        'orderQuantities': orderQuantities,
                      });
                      setState(() {
                        _isLoading = false;
                      });
                      print('Resultados: $orderQuantities');
                    },
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}