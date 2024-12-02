import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:frontend/widgets/product_dialog.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_order.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/widgets/tickets/ticket.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:ticket_widget/ticket_widget.dart';

class OrderMobile extends StatefulWidget {
  const OrderMobile({super.key});

  @override
  OrderMobileState createState() => OrderMobileState();
}

class OrderMobileState extends State<OrderMobile> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['Todos', 'Abierto', 'Pagado', 'Cancelado'];
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

      final results =
          await Future.wait([ordersFuture, productsFuture, customersFuture]);

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
      return allOrders
          .where((order) => order.status == selectedCategoryIndex - 1)
          .toList();
    }
  }

  Future<void> _showProductDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) =>
          ProductDialog(products: allProducts, customers: allCustomers),
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
        await loadData();
        setState(() {
          CustomSnackBar.show(context, 'Se creó la orden correctamente');
        });
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
    final Map<String, int> initialOrderQuantities = {
      for (var restockOrder in order.restockOrders ?? [])
        restockOrder.idProduct: restockOrder.quantity
    };

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ProductDialog(
        products: allProducts,
        customers: allCustomers,
        initialCustomer: order.customer,
        initialOrderQuantities: initialOrderQuantities,
      ),
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

      final restockOrders = order.restockOrders?.map((restockOrder) {
            return RestockOrder(
              idRestockOrder: restockOrder.idRestockOrder,
              idSupplier: restockOrder.idSupplier,
              idProduct: restockOrder.idProduct,
              idOrder: order.idOrder,
              restockOrderDate: restockOrder.restockOrderDate,
              quantity: orderQuantities[restockOrder.idProduct] ??
                  restockOrder.quantity,
              totalAmount: restockOrder.totalAmount,
              status: restockOrder.status,
              created: restockOrder.created,
              createdBy: restockOrder.createdBy,
            );
          }).toList() ??
          [];

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
        await loadData();
        setState(() {
          CustomSnackBar.show(context, 'Orden actualizada correctamente');
        });
      } catch (e) {
        if (mounted) {
          CustomSnackBar.show(context, 'Failed to update order: $e');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteOrder(Order order) async {
    final result =
        await showDeleteConfirmationDialog(context, order.idOrder, () {
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
    final result =
        await showCancelarConfirmationDialog(context, order, () async {
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

  List<RestockOrder> _createRestockOrders(Map<String, int> orderQuantities,
      [String orderId = '']) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    List<Order> filteredOrders = getFilteredOrders();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Master',
          style: TextStyle(
            fontSize: 24,
            color: theme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      drawer: const MobileDrawer(),
      body: Column(
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
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
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
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: TicketWidget(
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
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _showProductDialog,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.add),
      ),
    );
  }
}
