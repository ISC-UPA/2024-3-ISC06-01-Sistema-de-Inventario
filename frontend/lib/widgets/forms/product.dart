import 'package:flutter/material.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showProductDialog(BuildContext context, {Product? product}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId') ?? '';

  final nameController = TextEditingController(text: product?.name ?? '');
  final descriptionController = TextEditingController(text: product?.description ?? '');
  final priceController = TextEditingController(text: product?.price.toString() ?? '');
  final costController = TextEditingController(text: product?.cost.toString() ?? '');
  final stockController = TextEditingController(text: product?.stock.toString() ?? '');
  final categoryController = TextEditingController(text: product?.category.toString() ?? '');

  bool _isLoading = false;

  if (!context.mounted) return null;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(product == null ? 'Agregar Producto' : 'Editar Producto'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    maxLength: 100,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: costController,
                    decoration: const InputDecoration(labelText: 'Costo'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : () {
                  if (context.mounted) {
                    Navigator.of(context).pop(null);
                  }
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  setState(() {
                    _isLoading = true;
                  });

                  final name = nameController.text;
                  final description = descriptionController.text;
                  final price = double.tryParse(priceController.text) ?? 0;
                  final cost = double.tryParse(costController.text) ?? 0;
                  final stock = int.tryParse(stockController.text) ?? 0;
                  final category = int.tryParse(categoryController.text) ?? 0;

                  try {
                    if (product == null) {
                      final newProduct = {
                        'name': name,
                        'description': description,
                        'price': price,
                        'cost': cost,
                        'stock': stock,
                        'category': category,
                        'createdBy': userId,
                      };
                      await ApiServices().createProduct(newProduct);
                      CustomSnackBar.show(context, 'Producto creado exitosamente');
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      final updatedProduct = {
                        'name': name,
                        'description': description,
                        'price': price,
                        'cost': cost,
                        'stock': stock,
                        'category': category,
                        'updatedBy': userId,
                      };
                      await ApiServices().updateProduct(product.idProduct, updatedProduct);
                      CustomSnackBar.show(context, 'Producto actualizado exitosamente');
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading ? CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String productId) async {
  bool _isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    await ApiServices().deleteProduct(productId);
                    CustomSnackBar.show(context, 'Producto eliminado exitosamente');
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    CustomSnackBar.show(context, 'Error: ${e.toString()}');
                    if (context.mounted) {
                      Navigator.of(context).pop(null);
                    }
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    },
  );
}