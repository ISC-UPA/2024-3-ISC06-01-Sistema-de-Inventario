import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/services/auth_service.dart';

class ApiServices {
  final String baseUrl = 'http://localhost:5000';
  final AuthService _authService = AuthService();

  /////////////////////////////////////////////////////////////////////////////////////         PRODUCTOS

  Future<List<Product>> getAllProducts() async {
    final response = await _authService.get('$baseUrl/api/Product');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los productos');
    }
  }

  Future<Product> getProductById(String id) async {
    final response = await _authService.get('$baseUrl/api/Product/$id');
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el producto con ID $id');
    }
  }

  Future<void> createProduct(Map<String, dynamic> product) async {
    final response = await _authService.post(
      '$baseUrl/api/Product',
      product,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el producto');
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    final sanitizedProduct = product.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await _authService.put(
      '$baseUrl/api/Product/$id',
      sanitizedProduct,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el producto');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await _authService.delete('$baseUrl/api/Product?id=$id');
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el producto con ID $id');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////         USUARIOS

  Future<List<User>> getAllUsers() async {
    final response = await _authService.get('$baseUrl/api/User');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los empleados');
    }
  }

  Future<User> getUserById(String id) async {
    final response = await _authService.get('$baseUrl/api/User/$id');
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el empleado con ID $id');
    }
  }

  Future<void> createUser(Map<String, dynamic> user) async {
    final response = await _authService.post(
      '$baseUrl/api/User',
      user,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el empleado');
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> user) async {
    final sanitizedUser = user.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await _authService.put(
      '$baseUrl/api/User/$id',
      sanitizedUser,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el empleado');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await _authService.delete('$baseUrl/api/User?id=$id');
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el empleado con ID $id');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////         CUSTOMERS

  Future<List<Customer>> getAllCustomers() async {
    final response = await _authService.get('$baseUrl/api/Customer');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los clientes');
    }
  }

  Future<Customer> getCustomerById(String id) async {
    final response = await _authService.get('$baseUrl/api/Customer/$id');
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el cliente con ID $id');
    }
  }

  Future<void> createCustomer(Map<String, dynamic> customer) async {
    final response = await _authService.post(
      '$baseUrl/api/Customer',
      customer,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el cliente');
    }
  }

  Future<void> updateCustomer(String id, Map<String, dynamic> customer) async {
    final sanitizedCustomer = customer.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await _authService.put(
      '$baseUrl/api/Customer/$id',
      sanitizedCustomer,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el cliente');
    }
  }

  Future<void> deleteCustomer(String id) async {
    final response = await _authService.delete('$baseUrl/api/Customer?id=$id');
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el cliente con ID $id');
    }
  }
}