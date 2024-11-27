import 'package:frontend/models/model_user.dart';

class Customer {
  final String idCustomer;
  final String name;
  final String email;
  final bool isActive;
  final DateTime? created;
  final String? createdBy;
  final DateTime? updated;
  final String? updatedBy;
  final User? createdByUser;
  final User? updatedByUser;

  Customer({
    required this.idCustomer,
    required this.name,
    required this.email,
    required this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.createdByUser,
    this.updatedByUser,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      idCustomer: json['idCustomer'],
      name: json['name'],
      email: json['email'],
      isActive: json['isActive'],
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
      'idCustomer': idCustomer,
      'name': name,
      'email': email,
      'isActive': isActive,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated?.toIso8601String(),
      'updatedBy': updatedBy,
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}