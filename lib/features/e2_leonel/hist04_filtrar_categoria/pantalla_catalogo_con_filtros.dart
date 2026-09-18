/// Integración interna de la Épica 2.
///
/// Combina HIST03 (catálogo) con HIST04 (filtros). Se mantiene fuera de ambas
/// historias para que cada una pueda estudiarse y probarse por separado.

import 'package:flutter/material.dart';

import '../hist03_catalogo_general/producto.dart';
import '../hist03_catalogo_general/controlador_catalogo.dart';
import '../hist03_catalogo_general/tarjeta_producto.dart';
import 'controlador_filtro_categorias.dart';
import 'selector_categorias.dart';

class PantallaCatalogoConFiltros extends StatelessWidget {
  const PantallaCatalogoConFiltros({
    super.key,
    required this.catalogo,
    required this.filtros,
    required this.alAbrirProducto,
  });

  final ControladorCatalogo catalogo;
  final ControladorFiltroCategorias filtros;J  final ValueChanged<Producto> alAbrirProducto;

  /// Responsabilidad única: Interfaz: Construye la interfaz correspondiente a la responsabilidad de este widget.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([catalogo, filtros]),
      builder: (context, _) {
        final filtrando =
            filtros.categoriaSeleccionada != ControladorFiltroCategorias.todos;
        final productos = filtrando ? filtros.productos : catalogo.productos;
        final cargando = filtrando ? filtros.cargando : catalogo.cargando;
        final error = filtrando ? filtros.error : catalogo.error;
        return Column(
          children: [
            SelectorCategorias(
              controlador: filtros,
              alSeleccionarTodos: catalogo.cargar,
            ),
            Expanded(child: _contenido(productos, cargando, error)),
          ],
        );
      },
    );
  }

  /// Responsabilidad única: Ejecuta la operación interna `_contenido` usada únicamente por este componente.
  Widget _contenido(List<Producto> productos, bool cargando, String? error) {
    if (cargando && productos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) return Center(child: Text(error));
    if (productos.isEmpty) {
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
      itemCount: productos.length,
      itemBuilder: (_, indice) {
        final producto = productos[indice];
        return TarjetaProducto(
          producto: producto,
          alAbrir: () => alAbrirProducto(producto),
        );
      },
    );
  }
}
