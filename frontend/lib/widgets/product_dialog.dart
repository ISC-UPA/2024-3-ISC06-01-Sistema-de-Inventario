import 'package:flutter/material.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'dart:async';

class ProductDialog extends StatefulWidget {
  final List<Product> products;
  final List<Customer> customers;
  final Customer? initialCustomer;
  final Map<String, int>? initialOrderQuantities;

  const ProductDialog({
    super.key,
    required this.products,
    required this.customers,
    this.initialCustomer,
    this.initialOrderQuantities,
  });

  @override
  ProductDialogState createState() => ProductDialogState();
}

class ProductDialogState extends State<ProductDialog> {
  List<Product> filteredProducts = [];
  List<Customer> filteredCustomers = [];
  Map<String, int> orderQuantities = {};
  Customer? selectedCustomer;
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
    filteredCustomers = widget.customers;
    selectedCustomer = widget.initialCustomer;
    orderQuantities = widget.initialOrderQuantities ?? {};
  }

  void _filterProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 3), () {
      setState(() {
        filteredProducts = widget.products
            .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredProducts.sort((a, b) => b.stock.compareTo(a.stock));
      });
    });
  }

  void _filterCustomers(String query) {
    setState(() {
      filteredCustomers = widget.customers
          .where((customer) => customer.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _incrementQuantity(String productId) {
    setState(() {
      if (orderQuantities[productId] == null) {
        orderQuantities[productId] = 1;
      } else if (orderQuantities[productId]! < widget.products.firstWhere((product) => product.idProduct == productId).stock) {
        orderQuantities[productId] = orderQuantities[productId]! + 1;
      }
    });
  }

  void _decrementQuantity(String productId) {
    setState(() {
      if (orderQuantities[productId] != null && orderQuantities[productId]! > 0) {
        orderQuantities[productId] = orderQuantities[productId]! - 1;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Sección de clientes
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              onChanged: _filterCustomers,
                              decoration: InputDecoration(
                                labelText: 'Buscar cliente',
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
                              itemCount: filteredCustomers.length,
                              itemBuilder: (context, index) {
                                final customer = filteredCustomers[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: selectedCustomer == customer ? theme.primaryContainer : theme.surface,
                                  child: ListTile(
                                    title: Text(
                                      customer.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: selectedCustomer == customer ? theme.onPrimaryContainer : theme.onSurface,
                                      ),
                                    ),
                                    subtitle: Text(
                                      customer.email,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: selectedCustomer == customer ? theme.onPrimaryContainer : theme.onSurface,
                                      ),
                                    ),
                                    selected: selectedCustomer == customer,
                                    onTap: () {
                                      setState(() {
                                        selectedCustomer = customer;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Sección de productos
                    Expanded(
                      flex: 7,
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
                                          onPressed: _isLoading ? null : () => _decrementQuantity(product.idProduct),
                                        ),
                                        Text(
                                          orderQuantities[product.idProduct]?.toString() ?? '0',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: _isLoading ? null : () => _incrementQuantity(product.idProduct),
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
                      onPressed: _isLoading ? null : () {
                        if (selectedCustomer != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          Navigator.of(context).pop({
                            'customer': selectedCustomer,
                            'orderQuantities': orderQuantities,
                          });
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          CustomSnackBar.show(context, 'Por favor, selecciona un cliente.');
                        }
                      },
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}