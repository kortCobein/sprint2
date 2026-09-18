import 'package:flutter/material.dart';

import '../../core/contratos/sesion.dart';
import '../componentes/boton_ut.dart';
import '../componentes/campo_ut.dart';
import '../componentes/estado_error_ut.dart';
import '../dimensiones_ut.dart';
import '../pantallas/contenedor_responsive_ut.dart';

class PantallaLoginContratoUT extends StatefulWidget {
  const PantallaLoginContratoUT({
    super.key,
    required this.autenticacion,
    required this.alAutenticar,
  });

  final AutenticacionAplicacion autenticacion;
  final ValueChanged<SesionAplicacion> alAutenticar;

  @override
  State<PantallaLoginContratoUT> createState() =>
      _PantallaLoginContratoUTState();
}

class _PantallaLoginContratoUTState extends State<PantallaLoginContratoUT> {
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_cargando) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final sesion = await widget.autenticacion.iniciarSesion(
        usuario: _usuario.text,
        contrasena: _contrasena.text,
      );
      if (!mounted) return;
      widget.alAutenticar(sesion);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString().replaceFirst('Bad state: ', ''));
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ContenedorResponsiveUT(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DimensionesUT.espacio32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 58,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: DimensionesUT.espacio16),
                    Text(
                      'Sprint 2',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: DimensionesUT.espacio4),
                    Text(
                      'Acceso institucional UT',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: DimensionesUT.espacio32),
                    CampoUT(
                      etiqueta: 'Usuario',
                      controlador: _usuario,
                      icono: Icons.person_outline_rounded,
                      accionTeclado: TextInputAction.next,
                      habilitado: !_cargando,
                    ),
                    const SizedBox(height: DimensionesUT.espacio16),
                    CampoUT(
                      etiqueta: 'Contraseña',
                      controlador: _contrasena,
                      icono: Icons.lock_outline_rounded,
                      ocultarTexto: true,
                      accionTeclado: TextInputAction.done,
                      habilitado: !_cargando,
                      alEnviar: (_) => _entrar(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: DimensionesUT.espacio16),
                      EstadoErrorUT(
                        mensaje: _error!,
                        titulo: 'No fue posible iniciar sesión',
                      ),
                    ],
                    const SizedBox(height: DimensionesUT.espacio20),
                    BotonUT(
                      etiqueta: 'Iniciar sesión',
                      icono: Icons.login_rounded,
                      cargando: _cargando,
                      expandido: true,
                      alPresionar: _entrar,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
