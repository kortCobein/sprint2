import 'package:flutter/material.dart';

import 'core/integracion/integracion_aplicacion.dart';
import 'theme/integracion/constructor_aplicacion_ut.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final aplicacion = await IntegracionAplicacion.construir(
      constructor: const ConstructorAplicacionUT(),
    );

    runApp(aplicacion);
  } catch (error) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No fue posible iniciar la aplicación.\n\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
