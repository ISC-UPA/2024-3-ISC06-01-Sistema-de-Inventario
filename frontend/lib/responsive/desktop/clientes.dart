import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/widgets/forms/customer.dart';
import 'package:intl/intl.dart';

class ClientesDesktop extends StatefulWidget {
  const ClientesDesktop({super.key});

  @override
  ClientesDesktopState createState() => ClientesDesktopState();
}

class ClientesDesktopState extends State<ClientesDesktop> {
  List<Customer> _customers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final customers = await ApiServices().getAllCustomers();
      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<String> _getUserName(String userId) async {
    try {
      User user = await ApiServices().getUserById(userId);
      return user.userName;
    } catch (e) {
      return '';
    }
  }

  void _editCustomer(Customer customer) async {
    final updatedCustomer = await showCustomerDialog(context, customer: customer);
    if (updatedCustomer != null) {
      await _fetchCustomers();
    }
  }

  void _deleteCustomer(String customerId) async {
    final shouldDelete = await showDeleteConfirmationDialog(context, customerId);
    if (shouldDelete == true) {
      await _fetchCustomers();
    }
  }

  void _addCustomer() async {
    final newCustomer = await showCustomerDialog(context);
    if (newCustomer != null) {
      await _fetchCustomers();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          const DesktopMenu(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text('Error: $_error'))
                          : _customers.isEmpty
                              ? const Center(child: Text('No hay clientes disponibles'))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                      child: DataTable(
                                        headingRowColor: WidgetStateColor.resolveWith((states) => theme.primary),
                                        headingTextStyle: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.bold),
                                        columns: _buildColumns(),
                                        rows: _buildRows(_customers, theme),
                                      ),
                                    ),
                                  ),
                                ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        backgroundColor: theme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Creado')),
      DataColumn(label: Text('Creado Por')),
      DataColumn(label: Text('Actualizado')),
      DataColumn(label: Text('Actualizado Por')),
      DataColumn(label: Text('Acciones')),
    ];
  }

  List<DataRow> _buildRows(List<Customer> customers, ColorScheme theme) {
    return customers.map((customer) {
      return DataRow(
        cells: [
          DataCell(Text(customer.name)),
          DataCell(Text(customer.email)),
          DataCell(Text(_formatDate(customer.created))),
          DataCell(
            FutureBuilder<String>(
              future: _getUserName(customer.createdBy ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return Text(snapshot.data ?? 'Desconocido');
                }
              },
            ),
          ),
          DataCell(Text(_formatDate(customer.updated))),
          DataCell(
            FutureBuilder<String>(
              future: _getUserName(customer.updatedBy ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return Text(snapshot.data ?? 'Desconocido');
                }
              },
            ),
          ),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: theme.primary),
                  onPressed: () => _editCustomer(customer),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.error),
                  onPressed: () => _deleteCustomer(customer.idCustomer),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}