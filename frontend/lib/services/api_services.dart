import 'dart:convert';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_user.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl = 'http://localhost:5000';

  // Obtener todos los productos
  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Product'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los productos');
    }
  }

  // Obtener un producto por ID
  Future<Product> getProductById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Product/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el producto con ID $id');
    }
  }

  // Obtener un usuario por ID
  Future<User> getUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/User/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el usuario con ID $id');
    }
  }

  // Obtener todos los clientes
  Future<List<Customer>> getAllCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Customer'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los clientes');
    }
  }

  // Obtener un cliente por ID
  Future<Customer> getCustomerById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Customer/$id'));
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el cliente con ID $id');
    }
  }

  // Crear un cliente
  Future<Customer> createCustomer(Customer customer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Customer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customer.toJson()),
    );
    if (response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el cliente');
    }
  }

  // Actualizar un cliente
  Future<Customer> updateCustomer(Customer customer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Customer/${customer.idCustomer}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customer.toJson()),
    );
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el cliente');
    }
  }

  // Eliminar un cliente
  Future<void> deleteCustomer(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/Customer/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el cliente con ID $id');
    }
  }

  // Crear un producto
  Future<void> createProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Product'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode <= 200 && response.statusCode > 300) {
      print('Error: ${response.body}');
      throw Exception('Error al crear el producto');
    }
  }

  // Actualizar un producto
  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Product/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // La actualización fue exitosa
      return;
    } else {
      // La actualización falló
      print('Error: ${response.body}');
      throw Exception('Error al actualizar el producto');
    }
  }

  // Eliminar un producto
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/Product?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el producto con ID $id');
    }
  }
}