/// HIST03 - Visualizar catálogo general.
///
/// Esta pantalla representa únicamente el catálogo. La combinación con los
/// filtros de HIST04 vive en `../compartido/pantalla_catalogo_con_filtros.dart`.

import 'package:flutter/material.dart';

import 'producto.dart';
import 'controlador_catalogo.dart';
import 'tarjeta_producto.dart';

class PantallaCatalogo extends StatelessWidget {
  const PantallaCatalogo({
    super.key,
    required this.controlador,
    required this.alAbrirProducto,
  });

  final ControladorCatalogo controlador;
  final ValueChanged<Producto> alAbrirProducto;

  /// Responsabilidad única: Interfaz: Construye la interfaz correspondiente a la responsabilidad de este widget.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controlador,
      builder: (context, _) {
        if (controlador.cargando && controlador.productos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controlador.error != null) {
          return Center(child: Text(controlador.error!));
        }
        if (controlador.productos.isEmpty) {
          return const Center(child: Text('No hay productos disponibles.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controlador.productos.length,
          itemBuilder: (_, indice) {
            final producto = controlador.productos[indice];
            return TarjetaProducto(
              producto: producto,
              alAbrir: () => alAbrirProducto(producto),
            );
          },
        );
      },
    );
  }
}
