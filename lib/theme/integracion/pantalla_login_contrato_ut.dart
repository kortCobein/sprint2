import 'package:flutter/material.dart';

import '../../core/contratos/sesion.dart';
import '../colores_ut.dart';
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

  void _rellenar(String u, String p) {
    _usuario.text = u;
    _contrasena.text = p;
    setState(() => _error = null);
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
      backgroundColor: ColoresUT.azul,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: ColoresUT.verde,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                color: ColoresUT.azulMedio,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: ContenedorResponsiveUT(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 28,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          color: ColoresUT.azul,
                          padding: const EdgeInsets.fromLTRB(28, 26, 28, 22),
                          child: Column(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              child: const Icon(
                                Icons.school_rounded,
                                size: 42,
                                color: ColoresUT.azul,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'UTSJR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Universidad Tecnológica de San Juan del Río',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFDCE7F4),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 6,
                        color: ColoresUT.verde,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Acceso al sistema',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: ColoresUT.azul,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ingresa con tu perfil asignado o cuenta API.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ColoresUT.textoSecundario,
                                  ),
                            ),
                            const SizedBox(height: DimensionesUT.espacio24),
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
                              const SizedBox(
                                height: DimensionesUT.espacio16,
                              ),
                              EstadoErrorUT(
                                mensaje: _error!,
                                titulo: 'No fue posible iniciar sesión',
                              ),
                            ],
                            const SizedBox(height: DimensionesUT.espacio20),
                            BotonUT(
                              etiqueta: _cargando
                                  ? 'Autenticando…'
                                  : 'Iniciar sesión',
                              icono: Icons.login_rounded,
                              cargando: _cargando,
                              expandido: true,
                              alPresionar: _entrar,
                            ),
                            const SizedBox(height: DimensionesUT.espacio16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: ColoresUT.azulMuyClaro,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: ColoresUT.azulClaro,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Accesos rápidos para pruebas (toca para rellenar):',
                                    style: TextStyle(
                                      color: ColoresUT.azul,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      ActionChip(
                                        avatar: const Icon(Icons.admin_panel_settings, size: 16),
                                        label: const Text('Admin local (admin1)', style: TextStyle(fontSize: 11)),
                                        onPressed: _cargando ? null : () => _rellenar('admin1', '1'),
                                      ),
                                      ActionChip(
                                        avatar: const Icon(Icons.person, size: 16),
                                        label: const Text('Cliente local (cliente1)', style: TextStyle(fontSize: 11)),
                                        onPressed: _cargando ? null : () => _rellenar('cliente1', '4'),
                                      ),
                                      ActionChip(
                                        avatar: const Icon(Icons.cloud_sync_outlined, size: 16),
                                        label: const Text('API FakeStore (johnd)', style: TextStyle(fontSize: 11)),
                                        onPressed: _cargando ? null : () => _rellenar('johnd', 'm38rmF\$'),
                                      ),
                                      ActionChip(
                                        avatar: const Icon(Icons.shopping_bag_outlined, size: 16),
                                        label: const Text('API FakeStore (mor_2314)', style: TextStyle(fontSize: 11)),
                                        onPressed: _cargando ? null : () => _rellenar('mor_2314', '83r5^_'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
