import 'package:flutter/widgets.dart';

import '../contratos/constructor_aplicacion.dart';
import '../contratos/modulo_historia.dart';
import 'contenedor_dependencias.dart';
import 'registro_historias.g.dart';

/// Punto único de composición.
///
/// main.dart no necesita conocer historias, controladores, repositorios,
/// dependencias ni rutas concretas.
final class IntegracionAplicacion {
  const IntegracionAplicacion._();

  static Future<Widget> construir({
    required ConstructorAplicacion constructor,
  }) async {
    final modulos = construirModulosGenerados();
    final contenedor = ContenedorDependencias();

    _validarIdsUnicos(modulos);
    _validarDependencias(modulos);

    for (final modulo in modulos) {
      modulo.registrarDependencias(contenedor);
      await modulo.inicializar(contenedor);
    }

    return constructor.construir(modulos: List.unmodifiable(modulos));
  }

  static void _validarIdsUnicos(List<ModuloHistoria> modulos) {
    final vistos = <String>{};

    for (final modulo in modulos) {
      if (!vistos.add(modulo.id)) {
        throw StateError('Historia duplicada en el registro: ${modulo.id}');
      }
    }
  }

  static void _validarDependencias(List<ModuloHistoria> modulos) {
    final activas = modulos.map((modulo) => modulo.id).toSet();

    for (final modulo in modulos) {
      final faltantes = modulo.dependencias
          .where((dependencia) => !activas.contains(dependencia))
          .toList(growable: false);

      if (faltantes.isNotEmpty) {
        throw StateError(
          'La historia ${modulo.id} tiene dependencias inactivas: '
          '${faltantes.join(', ')}',
        );
      }
    }
  }
}
