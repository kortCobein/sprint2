/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'package:flutter/material.dart';
import 'producto.dart';

/// Presentación mínima de un producto. El tema global decide colores y formas.
class TarjetaProducto extends StatelessWidget {
  const TarjetaProducto({super.key, required this.producto, required this.alAbrir});
  final Producto producto;
  final VoidCallback alAbrir;

  /// Responsabilidad única: Interfaz: Construye la interfaz de este componente sin ejecutar directamente reglas de negocio ni llamadas HTTP.
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: InkWell(
          onTap: alAbrir,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Image.network(
                  producto.imagen, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported_outlined)),
                )),
                const SizedBox(height: 8),
                Text(producto.titulo, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('\$${producto.precio.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}
