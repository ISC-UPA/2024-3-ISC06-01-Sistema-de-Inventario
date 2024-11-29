import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_supplier.dart';
import 'package:frontend/models/model_user.dart';

class RestockOrder {
  final String idRestockOrder;
  final String idSupplier;
  final String idProduct;
  final DateTime restockOrderDate;
  final int quantity;
  final double totalAmount;
  final int status;
  final DateTime created;
  final String createdBy;
  final DateTime updated;
  final String updatedBy;
  final Supplier? supplier;
  final Product? product;
  User? createdByUser;
  User? updatedByUser;

  RestockOrder({
    required this.idRestockOrder,
    required this.idSupplier,
    required this.idProduct,
    required this.restockOrderDate,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    this.supplier,
    this.product,
    this.createdByUser,
    this.updatedByUser,
  });

  factory RestockOrder.fromJson(Map<String, dynamic> json) {
    return RestockOrder(
      idRestockOrder: json['idRestockOrder'],
      idSupplier: json['idSupplier'],
      idProduct: json['idProduct'],
      restockOrderDate: DateTime.parse(json['restockOrderDate']),
      quantity: json['quantity'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
      created: DateTime.parse(json['created']),
      createdBy: json['createdBy'],
      updated: DateTime.parse(json['updated']),
      updatedBy: json['updatedBy'],
      supplier: json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      createdByUser: json['createdByUser'] != null ? User.fromJson(json['createdByUser']) : null,
      updatedByUser: json['updatedByUser'] != null ? User.fromJson(json['updatedByUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRestockOrder': idRestockOrder,
      'idSupplier': idSupplier,
      'idProduct': idProduct,
      'restockOrderDate': restockOrderDate.toIso8601String(),
      'quantity': quantity,
      'totalAmount': totalAmount,
      'status': status,
      'created': created.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated.toIso8601String(),
      'updatedBy': updatedBy,
      'supplier': supplier?.toJson(),
      'product': product?.toJson(),
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}