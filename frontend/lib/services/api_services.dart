import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/models/model_supplier.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl = 'http://localhost:5000';
  final AuthService _authService = AuthService(); // Inicializa AuthService

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'accept': 'text/plain',
      'Authorization': 'Bearer $token',
    };
  }

  /////////////////////////////////////////////////////////////////////////////////////         PROVEEDORES

  Future<List<Supplier>> getAllSuppliers() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Supplier'), headers: headers);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Supplier.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los proveedores');
    }
  }

  Future<Supplier> getSupplierById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Supplier/$id'), headers: headers);
    if (response.statusCode == 200) {
      return Supplier.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el proveedor con ID $id');
    }
  }

  Future<void> createSupplier(Map<String, dynamic> supplier) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/Supplier'),
      headers: headers,
      body: json.encode(supplier),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el proveedor');
    }
  }

  Future<void> updateSupplier(String id, Map<String, dynamic> supplier) async {
    final headers = await _getHeaders();
    final sanitizedSupplier = supplier.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/Supplier'),
      headers: headers,
      body: json.encode(sanitizedSupplier),
    );
    
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el proveedor');
    }
  }

  Future<void> deleteSupplier(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/Supplier/$id'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el proveedor con ID $id');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////         PRODUCTOS

  Future<List<Product>> getAllProducts() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Product'), headers: headers);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los productos');
    }
  }

  Future<Product> getProductById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Product/$id'), headers: headers);
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el producto con ID $id');
    }
  }

  Future<void> createProduct(Map<String, dynamic> product) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/Product'),
      headers: headers,
      body: json.encode(product),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el producto');
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    final headers = await _getHeaders();
    final sanitizedProduct = product.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/Product'),
      headers: headers,
      body: json.encode(sanitizedProduct),
    );
    
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');


    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el producto');
    }
  }

  Future<void> deleteProduct(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/Product/$id'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el producto con ID $id');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////         USUARIOS

  Future<List<User>> getAllUsers() async {
    final headers = await _getHeaders();
    //print('Headers: $headers');

    final response = await http.get(Uri.parse('$baseUrl/api/User'), headers: headers);
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los empleados');
    }
  }

  Future<User> getUserById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/User/$id'), headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el empleado con ID $id');
    }
  }

  Future<void> createUser(Map<String, dynamic> user) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/User'),
      headers: headers,
      body: json.encode(user),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el empleado');
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> user) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/api/User'),
      headers: headers,
      body: json.encode(user),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el empleado');
    }
  }

  Future<void> deleteUser(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/User/$id'), headers: headers);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el empleado con ID $id');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////         CUSTOMERS

  Future<List<Customer>> getAllCustomers() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Customer'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los clientes');
    }
  }

  Future<Customer> getCustomerById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Customer/$id'), headers: headers);
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el cliente con ID $id');
    }
  }

  Future<void> createCustomer(Map<String, dynamic> customer) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/Customer'),
      headers: headers,
      body: json.encode(customer),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear el cliente');
    }
  }

  Future<void> updateCustomer(String id, Map<String, dynamic> customer) async {
    final headers = await _getHeaders();
    final sanitizedCustomer = customer.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/Customer'),
      headers: headers,
      body: json.encode(sanitizedCustomer),
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el cliente');
    }
  }

  Future<void> deleteCustomer(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/Customer/$id'), headers: headers);
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el cliente con ID $id');
    }
  }
}