import 'package:flutter/material.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:frontend/widgets/tickets/bar_code_widget.dart';
import 'package:frontend/models/model_order.dart';
import 'package:intl/intl.dart';

class TicketData extends StatefulWidget {
  final Order order;
  final ColorScheme theme;
  final Future<void> Function() onDelete;
  final Future<void> Function() onEdit;
  final Future<void> Function() onCancel;
  final Future<void> Function() onPago;

  const TicketData({
    super.key,
    required this.order,
    required this.theme,
    required this.onDelete,
    required this.onEdit,
    required this.onCancel,
    required this.onPago,
  });

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
  @override
  Widget build(BuildContext context) {
    IconData icon;
    String ticketClass;
    Color ticketColor;

    switch (widget.order.status) {
      case 0:
        icon = Icons.lock_open;
        ticketClass = 'Abierto';
        ticketColor = widget.theme.primary;
        break;
      case 1:
        icon = Icons.lock;
        ticketClass = 'Pagado';
        ticketColor = widget.theme.secondary;
        break;
      case 2:
        icon = Icons.cancel;
        ticketClass = 'Cancelado';
        ticketColor = widget.theme.error;
        break;
      default:
        icon = Icons.all_inclusive;
        ticketClass = 'Todos';
        ticketColor = widget.theme.primary;
    }

    String _formatDate(DateTime? date) {
      if (date == null) return '';
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }

    double totalAmount = 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120.0,
                height: 25.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(width: 1.0, color: ticketColor),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: ticketColor, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        ticketClass,
                        style: TextStyle(color: ticketColor),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: widget.theme.onSecondaryContainer),
                onSelected: (String result) {
                  switch (result) {
                    case 'edit':
                      widget.onEdit();
                      break;
                    case 'pagar':
                      widget.onPago();
                      break;
                    case 'cancelar':
                      widget.onCancel();
                      break;
                    case 'borrar':
                      widget.onDelete();
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String>> items = [];
                  if (widget.order.status == 0) {
                    items.addAll([
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Editar'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'pagar',
                        child: Text('Marcar como pagado'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'cancelar',
                        child: Text('Cancelar'),
                      ),
                    ]);
                  } else if (widget.order.status == 1) {
                    items.add(
                      const PopupMenuItem<String>(
                        value: 'cancelar',
                        child: Text('Cancelar'),
                      ),
                    );
                  } else if (widget.order.status == 2) {
                    items.add(
                      const PopupMenuItem<String>(
                        value: 'borrar',
                        child: Text('Borrar'),
                      ),
                    );
                  }
                  return items;
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.order.createdByUser != null)
                  ticketDetailsWidget(
                    'Fecha y Hora',
                    [
                      _formatDate(widget.order.orderDate),
                    ],
                    widget.theme
                  ),
                const SizedBox(height: 10),
                if (widget.order.createdByUser != null)
                  ticketDetailsWidget(
                    'Empleado',
                    [
                      widget.order.createdByUser!.userDisplayName,
                    ], 
                    widget.theme
                  ),
                const SizedBox(height: 10),
                if (widget.order.customer != null)
                  ticketDetailsWidget(
                    'Cliente',
                    [
                      widget.order.customer!.name,
                      widget.order.customer!.email,
                    ], 
                    widget.theme
                  ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ticketProductTitlesWidget('Cantidad', 'Producto', 'Subtotal', widget.theme),
          if (widget.order.restockOrders != null)
            ...widget.order.restockOrders!.map((restockOrder) {
              totalAmount += restockOrder.totalAmount;
              return ticketProductDetailsWidget(
                restockOrder.quantity.toString(),
                restockOrder.product?.name ?? 'Producto desconocido',
                restockOrder,
                widget.theme,
                widget.order.status
              );
            }),
          const SizedBox(height: 15),
          ticketProductTitlesWidget('Subtotal', '', totalAmount.toStringAsFixed(2), widget.theme),
          ticketProductTitlesWidget('IVA: 16%', '', (totalAmount * .16).toStringAsFixed(2), widget.theme),
          ticketProductTitlesWidget('Total', '', (totalAmount + (totalAmount * 0.16)).toStringAsFixed(2), widget.theme),
          const SizedBox(height: 15),
          Center(
            child: BarCodeWidget(
              data: widget.order.idOrder,
              width:  150,
              height: 150,
            ),
          ),
          Center(
            child: Text(
              widget.order.idOrder,
              style: TextStyle(
                color: widget.theme.onPrimaryFixedVariant,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(child: Text('Stock Master', style: TextStyle(color: widget.theme.onSecondaryContainer, fontSize: 15, fontWeight: FontWeight.bold))),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}









Future<bool?> showDeleteConfirmationDialog(BuildContext context, String orderId, Function onDelete) async {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text('¿Estás seguro de que deseas eliminar esta orden?'),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                  });
                  onDelete();
                  try {
                    await ApiServices().deleteOrder(orderId);
                    CustomSnackBar.show(context, 'Orden eliminada exitosamente');
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    },
  );
}



Future<bool?> showCancelarConfirmationDialog(BuildContext context, Order order, Function onCancelar) async {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Cancelación'),
            content: const Text('¿Estás seguro de que deseas cancelar esta orden?'),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Regresar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                  });
                  onCancelar();
                  order.status = 2;
                  try {
                    await ApiServices().updateOrder(order.idOrder, order.toUpdateJson());
                    CustomSnackBar.show(context, 'Orden cancelada exitosamente');
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Cancelar Orden'),
              ),
            ],
          );
        },
      );
    },
  );
}



Future<bool?> showPagadoConfirmationDialog(BuildContext context, Order order, Function onPagado) async {
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar'),
            content: const Text('¿Estás seguro de que deseas marcar como pagada esta orden?'),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                  });
                  onPagado();
                  order.status = 1;
                  try {
                    await ApiServices().updateOrder(order.idOrder, order.toUpdateJson());
                    CustomSnackBar.show(context, 'Orden pagada exitosamente');
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Pagar'),
              ),
            ],
          );
        },
      );
    },
  );
}