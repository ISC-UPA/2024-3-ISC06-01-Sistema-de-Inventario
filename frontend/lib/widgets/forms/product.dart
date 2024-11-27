// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/snake_bar.dart';
import 'package:frontend/models/model_product.dart';
import 'package:frontend/services/api_services.dart';

Future<bool?> showProductDialog(BuildContext context, {Product? product}) async {
  final AuthService authService = AuthService();
  final userId = await authService.getUserData().then((value) => value?.idUser);

  final nameController = TextEditingController(text: product?.name ?? '');
  final descriptionController = TextEditingController(text: product?.description ?? '');
  final priceController = TextEditingController(text: product?.price.toString() ?? '');
  final costController = TextEditingController(text: product?.cost.toString() ?? '');
  final stockController = TextEditingController(text: product?.stock.toString() ?? '');
  final minStockController = TextEditingController(text: product?.minStock.toString() ?? ''); // Nuevo campo

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del producto';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                          return 'El nombre solo puede contener letras, números y espacios';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la descripción del producto';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                          return 'La descripción solo puede contener letras, números y espacios';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el precio del producto';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingrese un precio válido';
                        }
                        if (double.parse(value) <= 0) {
                          return 'El precio debe ser mayor que cero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: costController,
                      decoration: const InputDecoration(labelText: 'Costo'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el costo del producto';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingrese un costo válido';
                        }
                        if (double.parse(value) <= 0) {
                          return 'El costo debe ser mayor que cero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el stock del producto';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingrese un stock válido';
                        }
                        if (int.parse(value) < 0) {
                          return 'El stock no puede ser negativo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: minStockController,
                      decoration: const InputDecoration(labelText: 'Stock Mínimo'), // Nuevo campo
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el stock mínimo del producto';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingrese un stock mínimo válido';
                        }
                        if (int.parse(value) < 0) {
                          return 'El stock mínimo no puede ser negativo';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  if (context.mounted) {
                    Navigator.of(context).pop(null);
                  }
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      isLoading = true;
                    });

                    final name = nameController.text;
                    final description = descriptionController.text;
                    final price = double.tryParse(priceController.text) ?? 0;
                    final cost = double.tryParse(costController.text) ?? 0;
                    final stock = int.tryParse(stockController.text) ?? 0;
                    final minStock = int.tryParse(minStockController.text) ?? 0; // Nuevo campo

                    try {
                      if (product == null) {
                        final newProduct = {
                          'product': {
                            'name': name,
                            'description': description,
                            'price': price,
                            'cost': cost,
                            'stock': stock,
                            'minStock': minStock, // Nuevo campo
                          },
                          'id': userId,
                        };
                        await ApiServices().createProduct(newProduct);
                        CustomSnackBar.show(context, 'Producto creado exitosamente');
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      } else {
                        final updatedProduct = {
                          'product': {
                            'idProduct': product.idProduct,
                            'name': name,
                            'description': description,
                            'price': price,
                            'cost': cost,
                            'stock': stock,
                            'minStock': minStock, // Nuevo campo
                          },
                          'id': userId,
                        };
                        await ApiServices().updateProduct(product.idProduct, updatedProduct);
                        CustomSnackBar.show(context, 'Producto actualizado exitosamente');
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      }
                    } catch (e) {
                      CustomSnackBar.show(context, 'Error: ${e.toString()}');
                      debugPrint(e.toString());
                      if (context.mounted) {
                        Navigator.of(context).pop(null);
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String productId) async {
  bool isLoading = false;

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
                onPressed: isLoading ? null : () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
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
                    isLoading = false;
                  });
                },
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    },
  );
}