import 'package:flutter/material.dart';

import '../../core/contratos/auditoria.dart';
import '../../core/contratos/carrito.dart';
import '../../core/contratos/sesion.dart';
import '../../core/integracion/contenedor_dependencias.dart';
import '../componentes/appbar_ut.dart';
import '../componentes/badge_rol_ut.dart';
import '../navegacion/navbar_ut.dart';
import '../pantallas/shell_ut.dart';
import 'pantalla_auditoria_contrato_ut.dart';
import 'pantalla_carrito_contrato_ut.dart';
import 'pantalla_catalogo_contrato_ut.dart';

class PantallaPrincipalContratoUT extends StatefulWidget {
  const PantallaPrincipalContratoUT({
    super.key,
    required this.sesion,
    required this.historiasActivas,
    required this.contenedor,
    required this.alCerrarSesion,
  });

  final SesionAplicacion sesion;
  final Set<String> historiasActivas;
  final ContenedorDependencias contenedor;
  final VoidCallback alCerrarSesion;

  @override
  State<PantallaPrincipalContratoUT> createState() =>
      _PantallaPrincipalContratoUTState();
}

class _PantallaPrincipalContratoUTState
    extends State<PantallaPrincipalContratoUT> {
  int _indice = 0;
  bool _cerrando = false;

  List<_DestinoPrincipal> get _destinos {
    final destinos = <_DestinoPrincipal>[
      _DestinoPrincipal(
        etiqueta: 'Catálogo',
        icono: Icons.storefront_outlined,
        iconoSeleccionado: Icons.storefront_rounded,
        construir: () => PantallaCatalogoContratoUT(
          sesion: widget.sesion,
          contenedor: widget.contenedor,
        ),
      ),
    ];

    if (widget.sesion.rol.puedeUsarCarrito &&
        (widget.contenedor.contiene<AgregarCarritoAplicacion>() ||
            widget.contenedor.contiene<GestionCarritoAplicacion>())) {
      destinos.add(
        _DestinoPrincipal(
          etiqueta: 'Carrito',
          icono: Icons.shopping_cart_outlined,
          iconoSeleccionado: Icons.shopping_cart_rounded,
          construir: () => PantallaCarritoContratoUT(
            sesion: widget.sesion,
            contenedor: widget.contenedor,
          ),
        ),
      );
    }

    if (widget.sesion.rol.puedeAuditar &&
        (widget.contenedor.contiene<UsuariosAplicacion>() ||
            widget.contenedor.contiene<AuditoriaCarritosAplicacion>())) {
      destinos.add(
        _DestinoPrincipal(
          etiqueta: 'Auditoría',
          icono: Icons.query_stats_outlined,
          iconoSeleccionado: Icons.query_stats_rounded,
          construir: () => PantallaAuditoriaContratoUT(
            sesion: widget.sesion,
            contenedor: widget.contenedor,
          ),
        ),
      );
    }

    return destinos;
  }

  Future<void> _cerrarSesion() async {
    if (_cerrando) return;

    final cierre =
        widget.contenedor.intentarObtener<CierreSesionAplicacion>();
    if (cierre == null) {
      widget.alCerrarSesion();
      return;
    }

    setState(() => _cerrando = true);

    try {
      await cierre.cerrarSesion();
      if (!mounted) return;
      widget.alCerrarSesion();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Bad state: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _cerrando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinos = _destinos;
    if (_indice >= destinos.length) {
      _indice = 0;
    }

    final actual = destinos[_indice];

    return ShellUT(
      appBar: AppBarUT(
        titulo: actual.etiqueta,
        subtitulo: widget.sesion.nombreVisible,
        acciones: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: BadgeRolUT(
                etiqueta: _etiquetaRol(widget.sesion.rol),
                estilo: _estiloRol(widget.sesion.rol),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrando ? null : _cerrarSesion,
            icon: _cerrando
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      navegacionInferior: destinos.length <= 1
          ? null
          : NavbarUT(
              items: destinos
                  .map(
                    (destino) => ItemNavbarUT(
                      etiqueta: destino.etiqueta,
                      icono: destino.icono,
                      iconoSeleccionado: destino.iconoSeleccionado,
                    ),
                  )
                  .toList(growable: false),
              indiceActual: _indice,
              alSeleccionar: (indice) {
                setState(() => _indice = indice);
              },
            ),
      child: KeyedSubtree(
        key: ValueKey(actual.etiqueta),
        child: actual.construir(),
      ),
    );
  }
}

final class _DestinoPrincipal {
  const _DestinoPrincipal({
    required this.etiqueta,
    required this.icono,
    required this.iconoSeleccionado,
    required this.construir,
  });

  final String etiqueta;
  final IconData icono;
  final IconData iconoSeleccionado;
  final Widget Function() construir;
}

String _etiquetaRol(RolAplicacion rol) => switch (rol) {
      RolAplicacion.administrador => 'Administrador',
      RolAplicacion.auditor => 'Auditor',
      RolAplicacion.cliente => 'Cliente',
    };

EstiloRolUT _estiloRol(RolAplicacion rol) => switch (rol) {
      RolAplicacion.administrador => EstiloRolUT.administrador,
      RolAplicacion.auditor => EstiloRolUT.auditor,
      RolAplicacion.cliente => EstiloRolUT.cliente,
    };
