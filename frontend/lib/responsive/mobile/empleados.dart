import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/model_user.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/forms/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EmpleadosMobile extends StatefulWidget {
  const EmpleadosMobile({super.key});

  @override
  EmpleadosMobileState createState() => EmpleadosMobileState();
}

class EmpleadosMobileState extends State<EmpleadosMobile> {
  List<User> _employees = [];
  bool _isLoading = true;
  String? _error;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    _fetchUserData();
  }

  Future<void> _fetchEmployees() async {
    try {
      final employees = await ApiServices().getAllUsers();
      setState(() {
        _employees = employees;
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

  void _editEmployee(User employee) async {
    final updatedEmployee = await showUserDialog(context, user: employee);
    if (updatedEmployee != null) {
      await _fetchEmployees();
    }
  }

  void _deleteEmployee(String userId) async {
    final shouldDelete = await showDeleteConfirmationDialog(context, userId);
    if (shouldDelete == true) {
      await _fetchEmployees();
    }
  }

  void _addEmployee() async {
    final newEmployee = await showUserDialog(context);
    if (newEmployee != null) {
      await _fetchEmployees();
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
          'Empleados',
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
              : _employees.isEmpty
                  ? const Center(child: Text('No hay empleados disponibles'))
                  : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith((states) => theme.primary),
                          headingTextStyle: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.bold),
                          columns: _buildColumns(),
                          rows: _buildRows(_employees, theme),
                        ),
                      ),
                  ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: theme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = [
      const DataColumn(label: Text('Nombre de Usuario')),
      const DataColumn(label: Text('Nombre Completo')),
      const DataColumn(label: Text('Rol')),
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

  List<DataRow> _buildRows(List<User> employees, ColorScheme theme) {
    return employees.map((employee) {
      final cells = [
        DataCell(Text(employee.userName)),
        DataCell(Text(employee.userDisplayName)),
        DataCell(Text(employee.role == 0 ? 'Administrador' : 'Empleado')),
        DataCell(Text(employee.email)),
        DataCell(Text(_formatDate(employee.created))),
        DataCell(Text(employee.createdByUser?.userDisplayName ?? '')),
        DataCell(Text(_formatDate(employee.updated))),
        DataCell(Text(employee.updatedByUser?.userDisplayName ?? '')),
      ];

      if (_user?.role == 0) {
        cells.add(
          DataCell(
            Row(
              children: [
                if (employee.idUser != '8c2495da-acbf-4deb-9d13-859c72566705') ...[
                  IconButton(
                    icon: Icon(Icons.edit, color: theme.primary),
                    onPressed: () => _editEmployee(employee),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: theme.error),
                    onPressed: () => _deleteEmployee(employee.idUser),
                  ),
                ],
              ],
            ),
          ),
        );
      }

      return DataRow(cells: cells);
    }).toList();
  }
}