import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/models/model_supplier.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/models/model_order.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ApiServices {

  // Singleton instance
  static final ApiServices _instance = ApiServices._internal();

  // Factory constructor
  factory ApiServices() {
    return _instance;
  }

  // Private constructor
  ApiServices._internal();

  final String baseUrl = 'http://192.168.1.222:5000';
  final AuthService _authService = AuthService(); // Inicializa AuthService
  final Map<String, User> _userCache = {}; // Mapa para almacenar usuarios en caché
  final Map<String, Product> _productCache = {}; // Mapa para almacenar productos en caché
  final Map<String, Customer> _customerCache = {}; // Mapa para almacenar clientes en caché
  final Map<String, List<RestockOrder>> _restockOrderCache = {}; // Mapa para almacenar órdenes de reabastecimiento en caché

  cleanCache(){
    _userCache.clear();
    _productCache.clear();
    _customerCache.clear();
    _restockOrderCache.clear();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'accept': 'text/plain',
      'Authorization': 'Bearer $token',
    };
  }

  Future<User> _getUserById(String id) async {
    if (_userCache.containsKey(id)) {
      return _userCache[id]!;
    }

    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/User/$id'), headers: headers);
    if (response.statusCode == 200) {
      final user = User.fromJson(json.decode(response.body));
      _userCache[id] = user;
      return user;
    } else {
      throw Exception('Error al obtener el usuario con ID $id');
    }
  }

  Future<Customer> _getCustomerById(String id) async {
    if (_customerCache.containsKey(id)) {
      return _customerCache[id]!;
    }

    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Customer/$id'), headers: headers);
    if (response.statusCode == 200) {
      final customer = Customer.fromJson(json.decode(response.body));
      _customerCache[id] = customer;
      return customer;
    } else {
      throw Exception('Error al obtener el cliente con ID $id');
    }
  }

  Future<void> _populateUserFields(dynamic entity) async {
    if (entity.createdByUser == null && entity.createdBy != null) {
      entity.createdByUser = await _getUserById(entity.createdBy!);
    }
    if (entity.updatedByUser == null && entity.updatedBy != null) {
      entity.updatedByUser = await _getUserById(entity.updatedBy!);
    }
  }

  Future<void> _populateCustomerFields(Order order) async {
    order.customer ??= await _getCustomerById(order.idCustomer);
  }

  /////////////////////////////////////////////////////////////////////////////////////         PROVEEDORES

  Future<List<Supplier>> getAllSuppliers() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Supplier'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final suppliers = data.map((json) => Supplier.fromJson(json)).toList();
      for (var supplier in suppliers) {
        await _populateUserFields(supplier);
      }
      return suppliers;
    } else {
      throw Exception('Error al obtener los proveedores');
    }
  }

  Future<Supplier> getSupplierById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Supplier/$id'), headers: headers);
    if (response.statusCode == 200) {
      final supplier = Supplier.fromJson(json.decode(response.body));
      await _populateUserFields(supplier);
      return supplier;
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
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final products = data.map((json) => Product.fromJson(json)).toList();
      for (var product in products) {
        await _populateUserFields(product);
      }
      return products;
    } else {
      throw Exception('Error al obtener los productos');
    }
  }

  Future<void> updateProductStock(String productId, int total) async {
    final headers = await _getHeaders();
    final body = json.encode({
      'productId': productId,
      'total': total,
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/Product/stock'),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 204) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar el stock del producto');
    }
  }

  Future<Product> _getProductById(String id) async {
    if (_productCache.containsKey(id)) {
      return _productCache[id]!;
    }

    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Product/$id'), headers: headers);
    if (response.statusCode == 200) {
      final product = Product.fromJson(json.decode(response.body));
      _productCache[id] = product;
      return product;
    } else {
      throw Exception('Error al obtener el producto con ID $id');
    }
  }

  Future<Product> getProductById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Product/$id'), headers: headers);
    if (response.statusCode == 200) {
      final product = Product.fromJson(json.decode(response.body));
      await _populateUserFields(product);
      return product;
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
    final response = await http.get(Uri.parse('$baseUrl/api/User'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los usuarios');
    }
  }

  Future<User> getUserById(String id) async {
    return _getUserById(id);
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
      final customers = data.map((json) => Customer.fromJson(json)).toList();
      for (var customer in customers) {
        await _populateUserFields(customer);
      }
      return customers;
    } else {
      throw Exception('Error al obtener los clientes');
    }
  }

  Future<Customer> getCustomerById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Customer/$id'), headers: headers);
    if (response.statusCode == 200) {
      final customer = Customer.fromJson(json.decode(response.body));
      await _populateUserFields(customer);
      return customer;
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

  /////////////////////////////////////////////////////////////////////////////////////         ORDENES

  Future<List<Order>> getAllOrders() async {
    // Clear the restock order cache
    _restockOrderCache.clear();

    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Order'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final orders = data.map((json) => Order.fromJson(json)).toList();
      for (var order in orders) {
        await _populateUserFields(order);
        await _populateCustomerFields(order);
        await _populateRestockOrders(order);
      }
      final filteredOrders = orders.where((order) => order.status < 3).toList();
      return filteredOrders;
    } else {
      debugPrint('Error al obtener las órdenes: ${response.body}');
      throw Exception('Error al obtener las órdenes');
    }
  }
  
  Future<void> _populateRestockOrders(Order order) async {
    if (_restockOrderCache.isEmpty) {
      final restockOrders = await getAllRestockOrders();
      for (var restockOrder in restockOrders) {
        if (!_restockOrderCache.containsKey(restockOrder.idOrder)) {
          _restockOrderCache[restockOrder.idOrder] = [];
        }
        _restockOrderCache[restockOrder.idOrder]!.add(restockOrder);
      }
    }

    order.restockOrders = _restockOrderCache[order.idOrder] ?? [];
  }

  Future<Order> getOrderById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/Order/$id'), headers: headers);
    if (response.statusCode == 200) {
      final order = Order.fromJson(json.decode(response.body));
      await _populateUserFields(order);
      await _populateCustomerFields(order);
      await _populateRestockOrders(order);
      return order;
    } else {
      throw Exception('Error al obtener la orden con ID $id');
    }
  }

  Future<void> createOrder(String id, Map<String, dynamic> order) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/Order/$id'),
      headers: headers,
      body: json.encode(order),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear la orden');
    }
  }

  Future<void> updateOrder(String id, Map<String, dynamic> order) async {
    final headers = await _getHeaders();
    final sanitizedOrder = order.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/Order'),
      headers: headers,
      body: json.encode(sanitizedOrder),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar la orden');
    }
  }

  Future<void> deleteOrder(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/Order/$id'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la orden con ID $id');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////         RESTOCK ORDERS

  Future<List<RestockOrder>> getAllRestockOrders() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/RestockOrder'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final restockOrders = data.map((json) => RestockOrder.fromJson(json)).toList();
      for (var restockOrder in restockOrders) {
        await _populateUserFields(restockOrder);
        await _populateProductFields(restockOrder);
      }
      return restockOrders;
    } else {
      throw Exception('Error al obtener las órdenes de reabastecimiento');
    }
  }

  Future<void> _populateProductFields(RestockOrder restockOrder) async {
    restockOrder.product ??= await _getProductById(restockOrder.idProduct);
  }

  Future<void> createRestockOrder(Map<String, dynamic> restockOrder) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/RestockOrder'),
      headers: headers,
      body: json.encode(restockOrder),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al crear la orden de reabastecimiento');
    }

      // Clear the restock order cache
      _restockOrderCache.clear();
  }

  Future<void> updateRestockOrder(String id, Map<String, dynamic> restockOrder) async {
    final headers = await _getHeaders();
    final sanitizedRestockOrder = restockOrder.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/RestockOrder/$id'),
      headers: headers,
      body: json.encode(sanitizedRestockOrder),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('Error: ${response.body}');
      throw Exception('Error al actualizar la orden de reabastecimiento');
    }

    // Clear the restock order cache
    _restockOrderCache.clear();

  }

  Future<void> deleteRestockOrder(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/RestockOrder/$id'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la orden de reabastecimiento con ID $id');
    }
      // Clear the restock order cache
      _restockOrderCache.clear();
  }

  /////////////////////////////////////////////////////////////////////////////////////         UPDATE ORDERS

  Future<List<Order>> updateOrders() async {
    try {
      List<Order> orders = await getAllOrders();
      List<RestockOrder> restockOrders = await getAllRestockOrders();
  
      // Map orders by id for quick lookup
      Map<String, Order> orderMap = {for (var order in orders) order.idOrder: order};
  
      // Assign restock orders to their respective orders
      for (var restockOrder in restockOrders) {
        if (orderMap.containsKey(restockOrder.idOrder)) {
          orderMap[restockOrder.idOrder]!.restockOrders ??= [];
          orderMap[restockOrder.idOrder]!.restockOrders!.add(restockOrder);
        }
      }
  
      return orders;
    } catch (e) {
      debugPrint('Failed to update orders: $e');
      rethrow;
    }
  }

  Future<void> createOrderWithRestock(Order order, List<RestockOrder> restockOrders) async {
    final headers = await _getHeaders();
    final AuthService authService = AuthService();
    final userID = await authService.getUserData().then((value) => value?.idUser);

    // Crear la orden
    final orderJson = order.toCreateJson();
    orderJson['id'] = userID;

    final orderResponse = await http.post(
      Uri.parse('$baseUrl/api/Order'),
      headers: headers,
      body: json.encode(orderJson),
    );

    if (orderResponse.statusCode < 200 || orderResponse.statusCode >= 300) {
      debugPrint('Error al crear la orden: ${orderResponse.body}');
      throw Exception('Error al crear la orden');
    }

    final recentOrder = await ApiServices().getAllOrders().then((orders) {
      return orders
          .where((order) => order.status < 3)
          .toList()
          ..sort((a, b) => b.created.compareTo(a.created));
    });
    
    final createdOrderID = recentOrder.first.idOrder;

    // Crear las órdenes de reabastecimiento
    for (var restockOrder in restockOrders) {
      restockOrder.idOrder = createdOrderID;
      restockOrder.idSupplier = "9a8ab899-1468-4da6-96d1-e40469add217";
      final restockOrderJson = restockOrder.toCreateJson();
      restockOrderJson['id'] = userID;

      final restockResponse = await http.post(
        Uri.parse('$baseUrl/api/RestockOrder'),
        headers: headers,
        body: json.encode(restockOrderJson),
      );

      if (restockResponse.statusCode < 200 || restockResponse.statusCode >= 300) {
        debugPrint('Error al crear la orden de reabastecimiento: ${restockResponse.body}');
        throw Exception('Error al crear la orden de reabastecimiento');
      }
    }
  }

  Future<void> updateOrderWithRestock(Order order, List<RestockOrder> restockOrders) async {
    final headers = await _getHeaders();
    final AuthService authService = AuthService();
    final userID = await authService.getUserData().then((value) => value?.idUser);

    print("Hola desde update");
    print(restockOrders);

    // Actualizar la orden
    final orderJson = order.toUpdateJson();
    orderJson['id'] = userID;

    final orderResponse = await http.put(
      Uri.parse('$baseUrl/api/Order'),
      headers: headers,
      body: json.encode(orderJson),
    );

    if (orderResponse.statusCode < 200 || orderResponse.statusCode >= 300) {
      debugPrint('Error al actualizar la orden: ${orderResponse.body}');
      throw Exception('Error al actualizar la orden');
    }

    // Actualizar las órdenes de reabastecimiento
    for (var restockOrder in restockOrders) {

      print(restockOrder.toCreateJson());
      if (restockOrder.idRestockOrder == ''){
        final rOrder = restockOrder.toCreateJson();
        rOrder['id'] = userID;
        createRestockOrder(rOrder);
      } else {
        final restockOrderJson = restockOrder.toUpdateJson();
        restockOrderJson['id'] = userID;

        final restockResponse = await http.put(
          Uri.parse('$baseUrl/api/RestockOrder'),
          headers: headers,
          body: json.encode(restockOrderJson),
        );

        if (restockResponse.statusCode < 200 || restockResponse.statusCode >= 300) {
          debugPrint('Error al actualizar la orden de reabastecimiento: ${restockResponse.body}');
          throw Exception('Error al actualizar la orden de reabastecimiento');
        }
      }

    }
  }
}