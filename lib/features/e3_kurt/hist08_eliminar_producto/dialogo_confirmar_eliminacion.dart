/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'package:flutter/material.dart';

/// Confirmación obligatoria de US08: nunca ejecutar DELETE con un solo toque.
Future<bool> confirmarEliminacion(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (contextoDialogo) => AlertDialog(
          title: const Text('Eliminar producto'),
          content: const Text('¿Estás seguro de eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(contextoDialogo, true),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ) ??
      false;
}
