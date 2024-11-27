import 'package:frontend/models/model_user.dart';

class Supplier {
  final String idSupplier;
  final String name;
  final String description;
  final DateTime? created;
  final String? createdBy;
  final DateTime? updated;
  final String? updatedBy;
  final User? createdByUser;
  final User? updatedByUser;

  Supplier({
    required this.idSupplier,
    required this.name,
    required this.description,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.createdByUser,
    this.updatedByUser,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      idSupplier: json['idSupplier'],
      name: json['name'],
      description: json['description'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      createdBy: json['createdBy'],
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      updatedBy: json['updatedBy'],
      createdByUser: json['createdByUser'] != null ? User.fromJson(json['createdByUser']) : null,
      updatedByUser: json['updatedByUser'] != null ? User.fromJson(json['updatedByUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSupplier': idSupplier,
      'name': name,
      'description': description,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated?.toIso8601String(),
      'updatedBy': updatedBy,
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}