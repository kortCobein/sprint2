import 'package:flutter/widgets.dart';

import 'core/integracion/integracion_aplicacion.dart';
import 'theme/integracion/constructor_aplicacion_ut.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final aplicacion = await IntegracionAplicacion.construir(
    constructor: const ConstructorAplicacionUT(),
  );

  runApp(aplicacion);
}
