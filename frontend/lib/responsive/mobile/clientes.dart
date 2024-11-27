import 'package:flutter/material.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_customer.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/forms/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClientesMobile extends StatefulWidget {
  const ClientesMobile({super.key});

  @override
  ClientesMobileState createState() => ClientesMobileState();
}

class ClientesMobileState extends State<ClientesMobile> {
  List<Customer> _customers = [];
  bool _isLoading = true;
  String? _error;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _fetchUserData();
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

  Future<void> _fetchUserData() async {
    try {
      final AuthService authService = AuthService();
      final user = await authService.getUserData();
      setState(() {
        _user = user;
      });
    } catch (e) {
      debugPrint(e.toString());
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
      appBar: AppBar(
        title: Text(
          'Clientes',
          style: GoogleFonts.patrickHand(
            textStyle: TextStyle(
              fontSize: 30,
              color: theme.onPrimary,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      drawer: const MobileDrawer(),
      body: _isLoading
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        backgroundColor: theme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = [
      const DataColumn(label: Text('Nombre')),
      const DataColumn(label: Text('Email')),
      const DataColumn(label: Text('Creado')),
      const DataColumn(label: Text('Creado Por')),
      const DataColumn(label: Text('Actualizado')),
      const DataColumn(label: Text('Actualizado Por')),
    ];

    if (_user?.role == 0) {
      columns.add(const DataColumn(label: Text('Acciones')));
    }

    return columns;
  }

  List<DataRow> _buildRows(List<Customer> customers, ColorScheme theme) {
    return customers.map((customer) {
      final cells = [
        DataCell(Text(customer.name)),
        DataCell(Text(customer.email)),
        DataCell(Text(_formatDate(customer.created))),
        DataCell(Text(customer.createdByUser?.userDisplayName ?? '')),
        DataCell(Text(_formatDate(customer.updated))),
        DataCell(Text(customer.updatedByUser?.userDisplayName ?? '')),
      ];

      if (_user?.role == 0) {
        cells.add(
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
        );
      }

      return DataRow(cells: cells);
    }).toList();
  }
}