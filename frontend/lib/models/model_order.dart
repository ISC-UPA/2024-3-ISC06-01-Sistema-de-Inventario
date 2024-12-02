import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/models/model_user.dart';

class Order {
  final String idOrder;
  final String idCustomer;
  final DateTime orderDate;
  final DateTime deliveryDate;
  int status;
  final DateTime created;
  final String createdBy;
  final DateTime? updated;
  final String? updatedBy;
  Customer? customer;
  User? createdByUser;
  User? updatedByUser;
  List<RestockOrder>? restockOrders;

  Order({
    required this.idOrder,
    required this.idCustomer,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.created,
    required this.createdBy,
    this.updated,
    this.updatedBy,
    this.customer,
    this.createdByUser,
    this.updatedByUser,
    this.restockOrders,
  });

  Map<String, dynamic> toCreateJson() {
    return {
      'order': {
        'idCustomer': idCustomer,
        'orderDate': orderDate.toIso8601String(),
        'deliveryDate': deliveryDate.toIso8601String(),
        'status': status,
      },
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'order': {
        'idOrder': idOrder,
        'idCustomer': idCustomer,
        'orderDate': orderDate.toIso8601String(),
        'deliveryDate': deliveryDate.toIso8601String(),
        'status': status,
      },
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      idOrder: json['idOrder'],
      idCustomer: json['idCustomer'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      status: json['status'],
      created: DateTime.parse(json['created']),
      createdBy: json['createdBy'],
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      updatedBy: json['updatedBy'],
    );
  }
}