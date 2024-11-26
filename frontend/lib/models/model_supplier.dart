import 'package:frontend/models/model_user.dart';

class Supplier {
  final String idSupplier;
  final String name;
  final String description;
  final int supplierStatus;
  final DateTime created;
  final String createdBy;
  final DateTime updated;
  final String updatedBy;
  final User? createdByUser;
  final User? updatedByUser;

  Supplier({
    required this.idSupplier,
    required this.name,
    required this.description,
    required this.supplierStatus,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    this.createdByUser,
    this.updatedByUser,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      idSupplier: json['idSupplier'],
      name: json['name'],
      description: json['description'],
      supplierStatus: json['supplierStatus'],
      created: DateTime.parse(json['created']),
      createdBy: json['createdBy'],
      updated: DateTime.parse(json['updated']),
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
      'supplierStatus': supplierStatus,
      'created': created.toIso8601String(),
      'createdBy': createdBy,
      'updated': updated.toIso8601String(),
      'updatedBy': updatedBy,
      'createdByUser': createdByUser?.toJson(),
      'updatedByUser': updatedByUser?.toJson(),
    };
  }
}
