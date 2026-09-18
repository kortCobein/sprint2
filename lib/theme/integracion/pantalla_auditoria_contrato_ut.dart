import 'package:flutter/material.dart';

import '../../core/contratos/auditoria.dart';
import '../../core/contratos/sesion.dart';
import '../../core/integracion/contenedor_dependencias.dart';
import '../componentes/estado_carga_ut.dart';
import '../componentes/estado_error_ut.dart';
import '../componentes/estado_vacio_ut.dart';
import '../dimensiones_ut.dart';
import '../pantallas/contenedor_responsive_ut.dart';

class PantallaAuditoriaContratoUT extends StatefulWidget {
  const PantallaAuditoriaContratoUT({
    super.key,
    required this.sesion,
    required this.contenedor,
  });

  final SesionAplicacion sesion;
  final ContenedorDependencias contenedor;

  @override
  State<PantallaAuditoriaContratoUT> createState() =>
      _PantallaAuditoriaContratoUTState();
}

class _PantallaAuditoriaContratoUTState
    extends State<PantallaAuditoriaContratoUT> {
  late Future<List<UsuarioAplicacion>> _usuarios;
  late Future<List<CarritoAuditoriaAplicacion>> _carritos;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  void _recargar() {
    final usuarios =
        widget.contenedor.intentarObtener<UsuariosAplicacion>();
    final carritos =
        widget.contenedor.intentarObtener<AuditoriaCarritosAplicacion>();

    _usuarios = usuarios == null
        ? Future.value(const <UsuarioAplicacion>[])
        : usuarios.listar(widget.sesion.rol);

    _carritos = carritos == null
        ? Future.value(const <CarritoAuditoriaAplicacion>[])
        : carritos.listar(widget.sesion.rol);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.sesion.rol.puedeAuditar) {
      return const EstadoErrorUT(
        titulo: 'Acceso restringido',
        mensaje: 'Esta sección es exclusiva para administradores y auditores.',
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.people_outline_rounded),
                text: 'Usuarios',
              ),
              Tab(
                icon: Icon(Icons.receipt_long_outlined),
                text: 'Carritos',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _UsuariosUT(futuro: _usuarios),
                _CarritosUT(futuro: _carritos),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsuariosUT extends StatelessWidget {
  const _UsuariosUT({required this.futuro});

  final Future<List<UsuarioAplicacion>> futuro;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsuarioAplicacion>>(
      future: futuro,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const EstadoCargaUT(mensaje: 'Cargando usuarios…');
        }

        if (snapshot.hasError) {
          return EstadoErrorUT(
            mensaje: _limpiarError(snapshot.error!),
          );
        }

        final usuarios = snapshot.data ?? const <UsuarioAplicacion>[];
        if (usuarios.isEmpty) {
          return const EstadoVacioUT(
            titulo: 'Sin usuarios',
            mensaje: 'No hay usuarios disponibles para auditoría.',
            icono: Icons.people_outline_rounded,
          );
        }

        return ContenedorResponsiveUT(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: DimensionesUT.espacio20,
            ),
            itemCount: usuarios.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: DimensionesUT.espacio12),
            itemBuilder: (context, indice) {
              final usuario = usuarios[indice];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      usuario.nombreCompleto.isEmpty
                          ? usuario.usuario.characters.first.toUpperCase()
                          : usuario.nombreCompleto.characters.first
                              .toUpperCase(),
                    ),
                  ),
                  title: Text(
                    usuario.nombreCompleto.isEmpty
                        ? usuario.usuario
                        : usuario.nombreCompleto,
                  ),
                  subtitle: Text(
                    '${usuario.correo}\n${usuario.telefono}',
                  ),
                  isThreeLine: true,
                  trailing: Text('#${usuario.id}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CarritosUT extends StatelessWidget {
  const _CarritosUT({required this.futuro});

  final Future<List<CarritoAuditoriaAplicacion>> futuro;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarritoAuditoriaAplicacion>>(
      future: futuro,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const EstadoCargaUT(
            mensaje: 'Cargando histórico de carritos…',
          );
        }

        if (snapshot.hasError) {
          return EstadoErrorUT(
            mensaje: _limpiarError(snapshot.error!),
          );
        }

        final carritos =
            snapshot.data ?? const <CarritoAuditoriaAplicacion>[];
        if (carritos.isEmpty) {
          return const EstadoVacioUT(
            titulo: 'Sin carritos',
            mensaje: 'No existe historial para mostrar.',
            icono: Icons.receipt_long_outlined,
          );
        }

        return ContenedorResponsiveUT(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: DimensionesUT.espacio20,
            ),
            itemCount: carritos.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: DimensionesUT.espacio12),
            itemBuilder: (context, indice) {
              final carrito = carritos[indice];
              return Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: Text(
                    'Carrito #${carrito.id} · Usuario #${carrito.usuarioId}',
                  ),
                  subtitle: Text(
                    carrito.fecha?.toLocal().toString() ?? 'Fecha no disponible',
                  ),
                  children: carrito.productos
                      .map(
                        (producto) => ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.inventory_2_outlined,
                            size: 20,
                          ),
                          title: Text(
                            producto.titulo ??
                                'Producto #${producto.productoId}',
                          ),
                          trailing: Text('x${producto.cantidad}'),
                        ),
                      )
                      .toList(growable: false),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

String _limpiarError(Object error) =>
    error.toString().replaceFirst('Bad state: ', '');
