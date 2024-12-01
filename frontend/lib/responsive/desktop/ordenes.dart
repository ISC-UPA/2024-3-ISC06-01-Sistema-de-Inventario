import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';
import 'package:frontend/widgets/product_dialog.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_order.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/widgets/tickets/ticket.dart';
import 'package:frontend/widgets/snake_bar.dart'; // Importar CustomSnackBar

class OrderDesktop extends StatefulWidget {
  const OrderDesktop({super.key});

  @override
  OrderDesktopState createState() => OrderDesktopState();
}

class OrderDesktopState extends State<OrderDesktop> {
  int selectedCategoryIndex = 0;
  final List<String> categories = [
    'Todos',
    'Abierto',
    'Pagado',
    'Cancelado'
  ];
  late List<Order> allOrders = [];
  late List<Product> allProducts = [];
  late List<Customer> allCustomers = [];
  late ApiServices apiServices;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    apiServices = ApiServices();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ordersFuture = apiServices.getAllOrders();
      final productsFuture = apiServices.getAllProducts();
      final customersFuture = apiServices.getAllCustomers();

      final results = await Future.wait([ordersFuture, productsFuture, customersFuture]);

      setState(() {
        allOrders = results[0] as List<Order>;
        allProducts = results[1] as List<Product>;
        allCustomers = results[2] as List<Customer>;
        _isLoading = false;
      });
    } catch (e) {
      CustomSnackBar.show(context, 'Failed to load data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Order> getFilteredOrders() {
    if (selectedCategoryIndex == 0) {
      return allOrders;
    } else {
      return allOrders.where((order) => order.status == selectedCategoryIndex - 1).toList();
    }
  }

  int calculateCrossAxisCount(double width) {
    if (width > 1200) {
      return 3;
    } else if (width > 800) {
      return 2;
    } else if (width > 600) {
      return 1;
    } else {
      return 1;
    }
  }

  Future<void> _showProductDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ProductDialog(products: allProducts, customers: allCustomers),
    );

    if (result != null) {
      final selectedCustomer = result['customer'] as Customer;
      final orderQuantities = result['orderQuantities'] as Map<String, int>;

      final newOrder = Order(
        idOrder: '',
        idCustomer: selectedCustomer.idCustomer,
        orderDate: DateTime.now(),
        deliveryDate: DateTime.now().add(const Duration(days: 7)),
        status: 0,
        created: DateTime.now(),
        createdBy: '',
      );

      final restockOrders = _createRestockOrders(orderQuantities);

      try {
        setState(() {
          _isLoading = true;
        });
        await apiServices.createOrderWithRestock(newOrder, restockOrders);
        setState(() {
          allOrders.add(newOrder);
        });
        CustomSnackBar.show(context, 'Se creó la orden correctamente');
      } catch (e) {
        CustomSnackBar.show(context, 'Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showEditProductDialog(Order order) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ProductDialog(products: allProducts, customers: allCustomers),
    );

    if (result != null) {
      final selectedCustomer = result['customer'] as Customer;
      final orderQuantities = result['orderQuantities'] as Map<String, int>;

      final updatedOrder = Order(
        idOrder: order.idOrder,
        idCustomer: selectedCustomer.idCustomer,
        orderDate: order.orderDate,
        deliveryDate: order.deliveryDate,
        status: order.status,
        created: order.created,
        createdBy: order.createdBy,
        updated: DateTime.now(),
        updatedBy: '', // Asignar el ID del usuario actual
      );

      final restockOrders = _createRestockOrders(orderQuantities, order.idOrder);

      try {
        setState(() {
          _isLoading = true;
        });
        await apiServices.updateOrderWithRestock(updatedOrder, restockOrders);
        setState(() {
          final index = allOrders.indexWhere((o) => o.idOrder == order.idOrder);
          if (index != -1) {
            allOrders[index] = updatedOrder;
          }
        });
        CustomSnackBar.show(context, 'Orden actualizada correctamente');
      } catch (e) {
        CustomSnackBar.show(context, 'Failed to update order: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteOrder(Order order) async {
    final result = await showDeleteConfirmationDialog(context, order.idOrder, () {
      setState(() {
        allOrders.removeWhere((o) => o.idOrder == order.idOrder);
      });
    });

    if (result == true) {
      CustomSnackBar.show(context, 'Orden eliminada correctamente');
    } else if (result == false) {
      CustomSnackBar.show(context, 'Eliminación cancelada');
    }
  }

  Future<void> _cancelarOrder(Order order) async {
    final result = await showCancelarConfirmationDialog(context, order, () async {
      order.status = 2; // Actualizar el estado a 2 (Cancelado)
      await apiServices.updateOrder(order.idOrder, order.toUpdateJson());
      setState(() {
        final index = allOrders.indexWhere((o) => o.idOrder == order.idOrder);
        if (index != -1) {
          allOrders[index] = order;
        }
      });
    });

    if (result == true) {
      CustomSnackBar.show(context, 'Orden cancelada correctamente');
    } else if (result == false) {
      CustomSnackBar.show(context, 'Cancelación cancelada');
    }
  }



  Future<void> _pagarOrder(Order order) async {
    final result = await showPagadoConfirmationDialog(context, order, () async {
      order.status = 1; // Actualizar el estado a 1 (Pagado)
      await apiServices.updateOrder(order.idOrder, order.toUpdateJson());
      setState(() {
        final index = allOrders.indexWhere((o) => o.idOrder == order.idOrder);
        if (index != -1) {
          allOrders[index] = order;
        }
      });
    });

    if (result == true) {
      CustomSnackBar.show(context, 'Orden pagada correctamente');
    } else if (result == false) {
      CustomSnackBar.show(context, 'Pago cancelado');
    }
  }

  List<RestockOrder> _createRestockOrders(Map<String, int> orderQuantities, [String orderId = '']) {
    return orderQuantities.entries.map((entry) {
      final productId = entry.key;
      final quantity = entry.value;
      final product = allProducts.firstWhere((p) => p.idProduct == productId);

      return RestockOrder(
        idRestockOrder: '',
        idSupplier: null,
        idProduct: productId,
        idOrder: orderId,
        restockOrderDate: DateTime.now(),
        quantity: quantity,
        totalAmount: product.price * quantity,
        status: 0,
        created: DateTime.now(),
        createdBy: '',
      );
    }).toList();
  }

  Future<void> _showConfirmationDialog(String action, Function onConfirm) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar $action'),
        content: Text('¿Estás seguro de que deseas $action este artículo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (result == true) {
      onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    List<Order> filteredOrders = getFilteredOrders();
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = calculateCrossAxisCount(screenWidth);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const DesktopMenu(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        if (_isLoading)
                          const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (allOrders.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text('No hay órdenes disponibles'),
                            ),
                          )
                        else ...[
                          Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(categories.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: selectedCategoryIndex == index
                                              ? theme.primary
                                              : theme.surface,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedCategoryIndex = index;
                                          });
                                        },
                                        child: Text(
                                          categories[index],
                                          style: TextStyle(
                                            color: selectedCategoryIndex == index
                                                ? theme.onPrimary
                                                : theme.onSurface,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 30.0,
                                mainAxisSpacing: 30.0,
                              ),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = filteredOrders[index];
                                print(order.restockOrders);
                                return TicketWidget(
                                  width: 350,
                                  height: 600,
                                  isCornerRounded: true,
                                  padding: const EdgeInsets.all(20),
                                  child: SingleChildScrollView(
                                    child: TicketData(
                                      order: order,
                                      theme: theme,
                                      onDelete: () => _deleteOrder(order),
                                      onEdit: () => _showEditProductDialog(order),
                                      onCancel: () => _cancelarOrder(order),
                                      onPago: () => _pagarOrder(order),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _showProductDialog,
        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.add),
      ),
    );
  }
}