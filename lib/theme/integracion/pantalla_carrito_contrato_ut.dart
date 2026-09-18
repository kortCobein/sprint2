import 'package:flutter/material.dart';

import '../../core/contratos/carrito.dart';
import '../../core/contratos/sesion.dart';
import '../../core/integracion/contenedor_dependencias.dart';
import '../componentes/boton_ut.dart';
import '../componentes/estado_error_ut.dart';
import '../componentes/estado_vacio_ut.dart';
import '../dimensiones_ut.dart';
import '../pantallas/contenedor_responsive_ut.dart';

class PantallaCarritoContratoUT extends StatefulWidget {
  const PantallaCarritoContratoUT({
    super.key,
    required this.sesion,
    required this.contenedor,
  });

  final SesionAplicacion sesion;
  final ContenedorDependencias contenedor;

  @override
  State<PantallaCarritoContratoUT> createState() =>
      _PantallaCarritoContratoUTState();
}

class _PantallaCarritoContratoUTState
    extends State<PantallaCarritoContratoUT> {
  String? _error;
  bool _trabajando = false;

  GestionCarritoAplicacion? get _gestion =>
      widget.contenedor.intentarObtener<GestionCarritoAplicacion>();
  AgregarCarritoAplicacion? get _agregar =>
      widget.contenedor.intentarObtener<AgregarCarritoAplicacion>();

  CarritoAplicacion get _estado {
    final gestion = _gestion;
    if (gestion != null) return gestion.estado;
    final agregar = _agregar;
    if (agregar != null) return agregar.estado;
    return CarritoAplicacion(usuario: widget.sesion.id, lineas: const []);
  }

  Future<void> _cambiarCantidad(
    int productoId,
    int cantidad,
  ) async {
    final gestion = _gestion;
    if (gestion == null || _trabajando) return;

    setState(() {
      _trabajando = true;
      _error = null;
    });

    try {
      await gestion.cambiarCantidad(
        rol: widget.sesion.rol,
        usuario: widget.sesion.id,
        productoId: productoId,
        cantidad: cantidad,
      );
    } catch (error) {
      _error = _limpiarError(error);
    } finally {
      if (mounted) {
        setState(() => _trabajando = false);
      }
    }
  }

  Future<void> _quitar(int productoId) async {
    final gestion = _gestion;
    if (gestion == null || _trabajando) return;

    setState(() {
      _trabajando = true;
      _error = null;
    });

    try {
      await gestion.quitar(
        rol: widget.sesion.rol,
        usuario: widget.sesion.id,
        productoId: productoId,
      );
    } catch (error) {
      _error = _limpiarError(error);
    } finally {
      if (mounted) {
        setState(() => _trabajando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = _estado;

    if (!widget.sesion.rol.puedeUsarCarrito) {
      return const EstadoErrorUT(
        titulo: 'Acceso restringido',
        mensaje: 'El carrito está disponible únicamente para clientes.',
      );
    }

    if (carrito.lineas.isEmpty) {
      return const EstadoVacioUT(
        titulo: 'Tu carrito está vacío',
        mensaje: 'Agrega productos desde el catálogo.',
        icono: Icons.shopping_cart_outlined,
      );
    }

    return ContenedorResponsiveUT(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: DimensionesUT.espacio20,
        ),
        children: [
          if (_error != null) ...[
            EstadoErrorUT(mensaje: _error!),
            const SizedBox(height: DimensionesUT.espacio16),
          ],
          ...carrito.lineas.map(
            (linea) => Card(
              child: Padding(
                padding: const EdgeInsets.all(DimensionesUT.espacio16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 68,
                      height: 68,
                      child: Image.network(
                        linea.producto.imagen,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(width: DimensionesUT.espacio16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            linea.producto.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: DimensionesUT.espacio4),
                          Text(
                            '\$${linea.subtotal.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _trabajando || _gestion == null
                          ? null
                          : () => _cambiarCantidad(
                                linea.producto.id,
                                linea.cantidad - 1,
                              ),
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text('${linea.cantidad}'),
                    IconButton(
                      onPressed: _trabajando || _gestion == null
                          ? null
                          : () => _cambiarCantidad(
                                linea.producto.id,
                                linea.cantidad + 1,
                              ),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                    IconButton(
                      onPressed: _trabajando || _gestion == null
                          ? null
                          : () => _quitar(linea.producto.id),
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: DimensionesUT.espacio20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                '\$${carrito.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          if (_gestion == null) ...[
            const SizedBox(height: DimensionesUT.espacio16),
            const Text(
              'US10 está inactiva; el carrito puede verse pero no editarse.',
            ),
          ],
          if (_trabajando) ...[
            const SizedBox(height: DimensionesUT.espacio16),
            const LinearProgressIndicator(),
          ],
          const SizedBox(height: DimensionesUT.espacio20),
          BotonUT(
            etiqueta: 'Seguir comprando',
            icono: Icons.storefront_outlined,
            variante: VarianteBotonUT.secundario,
            expandido: true,
            alPresionar: () {},
          ),
        ],
      ),
    );
  }
}

String _limpiarError(Object error) =>
    error.toString().replaceFirst('Bad state: ', '');
