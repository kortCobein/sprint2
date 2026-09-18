import 'package:flutter/material.dart';

import 'controlador_inicio_sesion.dart';
import 'sesion_usuario.dart';

/// Formulario reutilizable de la US01.
class FormularioInicioSesion extends StatefulWidget {
  const FormularioInicioSesion({
    super.key,
    required this.controlador,
    this.alAutenticar,
  });

  final ControladorInicioSesion controlador;

  /// La app principal decide a que pantalla navegar segun [SesionUsuario.rol].
  final ValueChanged<SesionUsuario>? alAutenticar;

  /// Responsabilidad única: Interfaz: Crea el estado asociado al widget y mantiene separada la configuración de su estado mutable.
  @override
  State<FormularioInicioSesion> createState() =>
      _FormularioInicioSesionState();
}

class _FormularioInicioSesionState extends State<FormularioInicioSesion> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controlUsuario = TextEditingController();
  final _controlContrasena = TextEditingController();
  bool _ocultarContrasena = true;

  /// Responsabilidad única: Libera controladores y recursos cuando el widget deja de utilizarse.
  @override
  void dispose() {
    _controlUsuario.dispose();
    _controlContrasena.dispose();
    super.dispose();
  }

  /// Responsabilidad única: Interfaz: Construye la interfaz correspondiente a la responsabilidad de este widget.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controlador,
      builder: (context, _) {
        return Form(
          key: _claveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _controlUsuario,
                enabled: !widget.controlador.cargando,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Ingresa tu usuario';
                  }
                  return null;
                },
                onChanged: (_) => widget.controlador.limpiarError(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controlContrasena,
                enabled: !widget.controlador.cargando,
                obscureText: _ocultarContrasena,
                onFieldSubmitted: (_) => _enviar(),
                decoration: InputDecoration(
                  labelText: 'Contrasena',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _ocultarContrasena ? 'Mostrar' : 'Ocultar',
                    onPressed: () {
                      setState(() => _ocultarContrasena = !_ocultarContrasena);
                    },
                    icon: Icon(
                      _ocultarContrasena
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Ingresa tu contrasena';
                  }
                  return null;
                },
                onChanged: (_) => widget.controlador.limpiarError(),
              ),
              if (widget.controlador.mensajeError != null) ...<Widget>[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.controlador.mensajeError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: widget.controlador.cargando ? null : _enviar,
                icon: widget.controlador.cargando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login),
                label: Text(
                  widget.controlador.cargando
                      ? 'Iniciando sesion...'
                      : 'Iniciar sesion',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Responsabilidad única: Interfaz: Valida la entrada del formulario y delega la operación al controlador.
  Future<void> _enviar() async {
    FocusScope.of(context).unfocus();
    if (!(_claveFormulario.currentState?.validate() ?? false)) return;

    final correcto = await widget.controlador.iniciarSesion(
      usuario: _controlUsuario.text,
      contrasena: _controlContrasena.text,
    );
    if (!mounted || !correcto) return;

    final sesion = widget.controlador.sesion;
    if (sesion != null) widget.alAutenticar?.call(sesion);
  }
}
