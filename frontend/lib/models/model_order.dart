// Modelo de Order
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_user.dart';

class Order {
  final String idOrder;
  final String idCustomer;
  final String idProduct;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final int quantity;
  final double totalAmount;
  final int status;
  final DateTime created;
  final String createdBy;
  final DateTime updated;
  final String updatedBy;
  final Customer? customer;
  final Product? product;
  final User? createdByUser;
  final User? updatedByUser;

  Order({
    required this.idOrder,
    required this.idCustomer,
    required this.idProduct,
    required this.orderDate,
    required this.deliveryDate,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    this.customer,
    this.product,
    this.createdByUser,
    this.updatedByUser,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      idOrder: json['idOrder'],
      idCustomer: json['idCustomer'],
      idProduct: json['idProduct'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      quantity: json['quantity'],
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      created: DateTime.parse(json['created']),
      createdBy: json['createdBy'],
      updated: DateTime.parse(json['updated']),
      updatedBy: json['updatedBy'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      createdByUser: json['createdByUser'] != null
          ? User.fromJson(json['createdByUser'])
          : null,
      updatedByUser: json['updatedByUser'] != null
          ? User.fromJson(json['updatedByUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idOrder': idOrder,
      'idCustomer': idCustomer,
      'idProduct': idProduct,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'quantity': quantity,
      'totalAmount': totalAmount,
      'status': status,
      'created': created.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated.toIso8601String(),
      'updatedBy': updatedBy,
      'customer': customer?.toJson(),
      'product': product?.toJson(),
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}
