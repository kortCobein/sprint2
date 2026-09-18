import 'package:flutter/material.dart';

import '../../core/contratos/constructor_aplicacion.dart';
import '../../core/contratos/sesion.dart';
import '../../core/integracion/contenedor_dependencias.dart';
import '../app_theme.dart';
import '../componentes/estado_carga_ut.dart';
import 'pantalla_login_contrato_ut.dart';
import 'pantalla_principal_contrato_ut.dart';

final class ConstructorAplicacionUT implements ConstructorAplicacion {
  const ConstructorAplicacionUT();

  @override
  Widget construir({
    required Set<String> historiasActivas,
    required ContenedorDependencias contenedor,
  }) {
    return _AplicacionUT(
      historiasActivas: historiasActivas,
      contenedor: contenedor,
    );
  }
}

class _AplicacionUT extends StatelessWidget {
  const _AplicacionUT({
    required this.historiasActivas,
    required this.contenedor,
  });

  final Set<String> historiasActivas;
  final ContenedorDependencias contenedor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprint 2',
      debugShowCheckedModeBanner: false,
      theme: AppThemeUT.claro,
      darkTheme: AppThemeUT.oscuro,
      themeMode: ThemeMode.light,
      home: _PuertaSesionUT(
        historiasActivas: historiasActivas,
        contenedor: contenedor,
      ),
    );
  }
}

class _PuertaSesionUT extends StatefulWidget {
  const _PuertaSesionUT({
    required this.historiasActivas,
    required this.contenedor,
  });

  final Set<String> historiasActivas;
  final ContenedorDependencias contenedor;

  @override
  State<_PuertaSesionUT> createState() => _PuertaSesionUTState();
}

class _PuertaSesionUTState extends State<_PuertaSesionUT> {
  SesionAplicacion? _sesion;
  bool _restaurando = true;

  @override
  void initState() {
    super.initState();
    _restaurar();
  }

  Future<void> _restaurar() async {
    final autenticacion =
        widget.contenedor.intentarObtener<AutenticacionAplicacion>();

    if (autenticacion != null) {
      try {
        _sesion = await autenticacion.restaurarSesion();
      } catch (_) {
        _sesion = null;
      }
    }

    if (mounted) {
      setState(() => _restaurando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_restaurando) {
      return const Scaffold(
        body: EstadoCargaUT(mensaje: 'Recuperando sesión…'),
      );
    }

    final sesion = _sesion;
    if (sesion == null) {
      final autenticacion =
          widget.contenedor.intentarObtener<AutenticacionAplicacion>();

      if (autenticacion == null) {
        return const Scaffold(
          body: Center(
            child: Text('US01 está inactiva. No hay flujo de autenticación.'),
          ),
        );
      }

      return PantallaLoginContratoUT(
        autenticacion: autenticacion,
        alAutenticar: (nuevaSesion) {
          setState(() => _sesion = nuevaSesion);
        },
      );
    }

    return PantallaPrincipalContratoUT(
      sesion: sesion,
      historiasActivas: widget.historiasActivas,
      contenedor: widget.contenedor,
      alCerrarSesion: () {
        setState(() => _sesion = null);
      },
    );
  }
}
