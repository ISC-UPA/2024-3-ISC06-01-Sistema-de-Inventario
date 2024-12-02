import 'package:frontend/models/model_user.dart';

class Product {
  final String idProduct;
  final String name;
  final String description;
  final double price;
  final double cost;
  final int stock;
  final int minStock; // Nuevo campo
  final DateTime? created;
  final String? createdBy;
  final DateTime? updated;
  final String? updatedBy;
  User? createdByUser;
  User? updatedByUser;

  Product({
    required this.idProduct,
    required this.name,
    required this.description,
    required this.price,
    required this.cost,
    required this.stock,
    required this.minStock, // Nuevo campo
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.createdByUser,
    this.updatedByUser,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: json['idProduct'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      cost: json['cost'].toDouble(),
      stock: json['stock'],
      minStock: json['minStock'], // Nuevo campo
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      createdBy: json['createdBy'],
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      updatedBy: json['updatedBy'],
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
      'idProduct': idProduct,
      'name': name,
      'description': description,
      'price': price,
      'cost': cost,
      'stock': stock,
      'minStock': minStock, // Nuevo campo
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated?.toIso8601String(),
      'updatedBy': updatedBy,
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}