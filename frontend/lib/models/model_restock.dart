import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_supplier.dart';
import 'package:frontend/models/model_user.dart';

class RestockOrder {
  final String idRestockOrder;
  String? idSupplier;
  final String idProduct;
  String idOrder;
  final DateTime restockOrderDate;
  final int quantity;
  final double totalAmount;
  final int status;
  final DateTime created;
  final String createdBy;
  final DateTime? updated;
  final String? updatedBy;
  final Supplier? supplier;
  Product? product;
  User? createdByUser;
  User? updatedByUser;

  RestockOrder({
    required this.idRestockOrder,
    required this.idSupplier,
    required this.idProduct,
    required this.idOrder,
    required this.restockOrderDate,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.created,
    required this.createdBy,
    this.updated,
    this.updatedBy,
    this.supplier,
    this.product,
    this.createdByUser,
    this.updatedByUser,
  });

  Map<String, dynamic> toCreateJson() {
    return {
      'restockOrder': {
        'idSupplier': idSupplier,
        'idProduct': idProduct,
        'idOrder': idOrder,
        'restockOrderDate': restockOrderDate.toIso8601String(),
        'quantity': quantity,
        'totalAmount': totalAmount,
        'status': status,
      },
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'restockOrder': {
        'idRestockOrder': idRestockOrder,
        'idSupplier': idSupplier,
        'idProduct': idProduct,
        'idOrder': idOrder,
        'restockOrderDate': restockOrderDate.toIso8601String(),
        'quantity': quantity,
        'totalAmount': totalAmount,
        'status': status,
      },
    };
  }

  factory RestockOrder.fromJson(Map<String, dynamic> json) {
    return RestockOrder(
      idRestockOrder: json['idRestockOrder'],
      idSupplier: json['idSupplier'],
      idProduct: json['idProduct'],
      idOrder: json['idOrder'],
      restockOrderDate: DateTime.parse(json['restockOrderDate']),
      quantity: json['quantity'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
      created: DateTime.parse(json['created']),
      createdBy: json['createdBy'],
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      updatedBy: json['updatedBy'],
    );
  }
}