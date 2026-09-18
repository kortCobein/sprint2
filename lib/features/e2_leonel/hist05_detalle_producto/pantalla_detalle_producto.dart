/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'package:flutter/material.dart';
import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../hist03_catalogo_general/producto.dart';
import 'controlador_detalle_producto.dart';

/// US05 decide qué acciones se muestran según el rol. Las acciones concretas
/// de inventario y carrito se inyectan después para no mezclar épicas.
class PantallaDetalleProducto extends StatelessWidget {
  const PantallaDetalleProducto({
    super.key, required this.controlador, required this.idProducto, required this.rol,
    this.alEditar, this.alEliminar, this.alAgregarCarrito,
  });
  final ControladorDetalleProducto controlador;
  final int idProducto;
  final RolUsuario rol;
  final ValueChanged<Producto>? alEditar;
  final ValueChanged<Producto>? alEliminar;
  final void Function(Producto producto, int cantidad)? alAgregarCarrito;

  /// Responsabilidad única: Interfaz: Construye la interfaz de este componente sin ejecutar directamente reglas de negocio ni llamadas HTTP.
  @override Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controlador, builder: (context, _) {
      if (controlador.cargando) return const Center(child: CircularProgressIndicator());
      if (controlador.error != null) return Center(child: Text(controlador.error!));
      final p=controlador.producto; if (p==null) return const SizedBox.shrink();
      return ListView(padding: const EdgeInsets.all(20), children: [
        SizedBox(height: 250, child: Image.network(p.imagen, fit: BoxFit.contain)),
        const SizedBox(height: 18), Text(p.titulo, style: Theme.of(context).textTheme.headlineSmall),
        Text('\$${p.precio.toStringAsFixed(2)}'), const SizedBox(height: 8),
        Chip(label: Text(p.categoria)), const SizedBox(height: 8), Text(p.descripcion),
        if (rol.puedeGestionarProductos) ...[
          const SizedBox(height: 20),
          Row(children:[
            Expanded(child: FilledButton(onPressed: ()=>alEditar?.call(p), child: const Text('Editar'))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton.tonal(onPressed: ()=>alEliminar?.call(p), child: const Text('Eliminar'))),
          ]),
        ],
        if (rol.puedeUsarCarrito && alAgregarCarrito != null) ...[
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: ()=>alAgregarCarrito!(p,1), icon: const Icon(Icons.add_shopping_cart), child: const Text('Agregar al carrito')),
        ],
      ]);
    });
  }
}
