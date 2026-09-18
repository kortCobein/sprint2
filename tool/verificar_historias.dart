import 'dart:io';

import 'configuracion_historias.dart';

const _salida = 'lib/core/integracion/registro_historias.g.dart';

Future<void> main() async {
  final sana = <String, bool>{};
  final motivo = <String, String>{};

  for (final historia in historias) {
    if (!historia.habilitada) {
      sana[historia.id] = false;
      motivo[historia.id] = 'desactivada_manual';
      continue;
    }

    final archivo = File(historia.rutaAdaptador);
    if (!archivo.existsSync()) {
      sana[historia.id] = false;
      motivo[historia.id] = 'adaptador_ausente';
      continue;
    }

    final analisis = await Process.run(
      'dart',
      ['analyze', historia.rutaAdaptador],
      runInShell: Platform.isWindows,
    );

    final correcta = analisis.exitCode == 0;
    sana[historia.id] = correcta;
    motivo[historia.id] = correcta ? 'sana' : 'analisis_fallido';

    if (!correcta) {
      stderr.writeln('ERROR ${historia.id}:');
      stderr.writeln(analisis.stdout);
      stderr.writeln(analisis.stderr);
    }
  }

  final activa = <String, bool>{
    for (final historia in historias)
      historia.id: sana[historia.id] ?? false,
  };

  var cambio = true;
  while (cambio) {
    cambio = false;

    for (final historia in historias) {
      if (!(activa[historia.id] ?? false)) {
        continue;
      }

      final dependenciasActivas = historia.dependencias.every(
        (dependencia) => activa[dependencia] ?? false,
      );

      if (!dependenciasActivas) {
        activa[historia.id] = false;
        motivo[historia.id] = 'dependencia_inactiva';
        cambio = true;
      }
    }
  }

  final buffer = StringBuffer()
    ..writeln('// ARCHIVO GENERADO.')
    ..writeln('// No editar manualmente.')
    ..writeln('// Generado por: dart run tool/verificar_historias.dart')
    ..writeln()
    ..writeln("import '../contratos/modulo_historia.dart';");

  for (final historia in historias) {
    if (activa[historia.id] ?? false) {
      final nombre = historia.rutaAdaptador.split('/').last;
      buffer.writeln(
        "import '../adaptadores/$nombre' as ${historia.alias};",
      );
    }
  }

  buffer
    ..writeln()
    ..writeln('List<ModuloHistoria> construirModulosGenerados() => <ModuloHistoria>[');

  for (final historia in historias) {
    if (activa[historia.id] ?? false) {
      buffer.writeln('  ${historia.alias}.crearModulo(),');
    }
  }

  buffer
    ..writeln('];')
    ..writeln()
    ..writeln('const Map<String, String> estadoHistoriasGeneradas = <String, String>{');

  for (final historia in historias) {
    final estado = (activa[historia.id] ?? false)
        ? 'activa'
        : (motivo[historia.id] ?? 'inactiva');

    buffer.writeln("  '${historia.id}': '$estado',");
  }

  buffer
    ..writeln('};')
    ..writeln();

  File(_salida)
    ..createSync(recursive: true)
    ..writeAsStringSync(buffer.toString());

  stdout.writeln('Registro generado en $_salida');
  for (final historia in historias) {
    stdout.writeln(
      '${historia.id}: ${(activa[historia.id] ?? false) ? 'ACTIVA' : motivo[historia.id]}',
    );
  }
}
