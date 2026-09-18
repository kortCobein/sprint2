import 'package:flutter/material.dart';

/// Campo visual UT configurable desde una feature o adaptador.
class CampoUT extends StatelessWidget {
  const CampoUT({
    super.key,
    required this.etiqueta,
    this.controlador,
    this.hint,
    this.icono,
    this.iconoFinal,
    this.tipoTeclado,
    this.accionTeclado,
    this.ocultarTexto = false,
    this.habilitado = true,
    this.soloLectura = false,
    this.errorTexto,
    this.maxLineas = 1,
    this.minLineas,
    this.alCambiar,
    this.alEnviar,
    this.alTocar,
    this.validador,
    this.autofillHints,
  });

  final String etiqueta;
  final TextEditingController? controlador;
  final String? hint;
  final IconData? icono;
  final Widget? iconoFinal;
  final TextInputType? tipoTeclado;
  final TextInputAction? accionTeclado;
  final bool ocultarTexto;
  final bool habilitado;
  final bool soloLectura;
  final String? errorTexto;
  final int maxLineas;
  final int? minLineas;
  final ValueChanged<String>? alCambiar;
  final ValueChanged<String>? alEnviar;
  final VoidCallback? alTocar;
  final FormFieldValidator<String>? validador;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: tipoTeclado,
      textInputAction: accionTeclado,
      obscureText: ocultarTexto,
      enabled: habilitado,
      readOnly: soloLectura,
      maxLines: ocultarTexto ? 1 : maxLineas,
      minLines: ocultarTexto ? 1 : minLineas,
      onChanged: alCambiar,
      onFieldSubmitted: alEnviar,
      onTap: alTocar,
      validator: validador,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: hint,
        errorText: errorTexto,
        prefixIcon: icono == null ? null : Icon(icono),
        suffixIcon: iconoFinal,
      ),
    );
  }
}
