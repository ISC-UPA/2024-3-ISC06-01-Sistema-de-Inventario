import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_supplier.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/forms/supplier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProveedoresMobile extends StatefulWidget {
  const ProveedoresMobile({super.key});

  @override
  ProveedoresMobileState createState() => ProveedoresMobileState();
}

class ProveedoresMobileState extends State<ProveedoresMobile> {
  List<Supplier> _suppliers = [];
  bool _isLoading = true;
  String? _error;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
    _fetchUserData();
  }

  Future<void> _fetchSuppliers() async {
    try {
      final suppliers = await ApiServices().getAllSuppliers();
      setState(() {
        _suppliers = suppliers;
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

  void _editSupplier(Supplier supplier) async {
    final updatedSupplier = await showSupplierDialog(context, supplier: supplier);
    if (updatedSupplier != null) {
      await _fetchSuppliers();
    }
  }

  void _deleteSupplier(String supplierId) async {
    final shouldDelete = await showDeleteConfirmationDialog(context, supplierId);
    if (shouldDelete == true) {
      await _fetchSuppliers();
    }
  }

  void _addSupplier() async {
    final newSupplier = await showSupplierDialog(context);
    if (newSupplier != null) {
      await _fetchSuppliers();
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
          'Proveedores',
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
              : _suppliers.isEmpty
                  ? const Center(child: Text('No hay proveedores disponibles'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith((states) => theme.primary),
                          headingTextStyle: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.bold),
                          columns: _buildColumns(),
                          rows: _buildRows(_suppliers, theme),
                        ),
                      ),
                  ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSupplier,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = [
      const DataColumn(label: Text('Nombre')),
      const DataColumn(label: Text('Descripción')),
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

  List<DataRow> _buildRows(List<Supplier> suppliers, ColorScheme theme) {
    return suppliers.map((supplier) {
      final cells = [
        DataCell(Text(supplier.name)),
        DataCell(Text(supplier.description)),
        DataCell(Text(_formatDate(supplier.created))),
        DataCell(Text(supplier.createdByUser?.userDisplayName ?? '')),
        DataCell(Text(_formatDate(supplier.updated))),
        DataCell(Text(supplier.updatedByUser?.userDisplayName ?? '')),
      ];

      if (_user?.role == 0) {
        cells.add(
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: theme.primary),
                  onPressed: () => _editSupplier(supplier),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.error),
                  onPressed: () => _deleteSupplier(supplier.idSupplier),
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