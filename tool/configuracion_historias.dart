final class DefinicionHistoria {
  const DefinicionHistoria({
    required this.id,
    required this.habilitada,
    required this.rutaAdaptador,
    required this.alias,
    this.dependencias = const <String>[],
  });

  final String id;
  final bool habilitada;
  final String rutaAdaptador;
  final String alias;
  final List<String> dependencias;
}

/// Configuración manual.
///
/// Regla de activación final:
/// habilitada && sana && dependencias activas.
///
/// Si una historia está en false, el verificador nunca la reactiva.
const historias = <DefinicionHistoria>[
  DefinicionHistoria(
    id: 'us01',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us01_adaptador.dart',
    alias: 'us01',
  ),
  DefinicionHistoria(
    id: 'us02',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us02_adaptador.dart',
    alias: 'us02',
    dependencias: ['us01'],
  ),
  DefinicionHistoria(
    id: 'us03',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us03_adaptador.dart',
    alias: 'us03',
  ),
  DefinicionHistoria(
    id: 'us04',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us04_adaptador.dart',
    alias: 'us04',
    dependencias: ['us03'],
  ),
  DefinicionHistoria(
    id: 'us05',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us05_adaptador.dart',
    alias: 'us05',
    dependencias: ['us01', 'us03'],
  ),
  DefinicionHistoria(
    id: 'us06',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us06_adaptador.dart',
    alias: 'us06',
    dependencias: ['us01', 'us03'],
  ),
  DefinicionHistoria(
    id: 'us07',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us07_adaptador.dart',
    alias: 'us07',
    dependencias: ['us01', 'us03', 'us06'],
  ),
  DefinicionHistoria(
    id: 'us08',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us08_adaptador.dart',
    alias: 'us08',
    dependencias: ['us01'],
  ),
  DefinicionHistoria(
    id: 'us09',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us09_adaptador.dart',
    alias: 'us09',
    dependencias: ['us01', 'us03'],
  ),
  DefinicionHistoria(
    id: 'us10',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us10_adaptador.dart',
    alias: 'us10',
    dependencias: ['us01', 'us09'],
  ),
  DefinicionHistoria(
    id: 'us11',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us11_adaptador.dart',
    alias: 'us11',
    dependencias: ['us01'],
  ),
  DefinicionHistoria(
    id: 'us12',
    habilitada: true,
    rutaAdaptador: 'lib/core/adaptadores/us12_adaptador.dart',
    alias: 'us12',
    dependencias: ['us01'],
  ),
];
