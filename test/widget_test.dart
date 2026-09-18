import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprint_02/core/integracion/integracion_aplicacion.dart';
import 'package:sprint_02/theme/integracion/constructor_aplicacion_ut.dart';

void main() {
  testWidgets('la app permite entrar como admin1 con clave 1', (tester) async {
    final app = await IntegracionAplicacion.construir(
      constructor: const ConstructorAplicacionUT(),
    );

    await tester.pumpWidget(app);
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Acceso al sistema'), findsOneWidget);

    final campos = find.byType(TextFormField);
    expect(campos, findsNWidgets(2));

    await tester.enterText(campos.at(0), 'admin1');
    await tester.enterText(campos.at(1), '1');
    await tester.ensureVisible(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar sesión'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Catálogo'), findsWidgets);
    expect(find.text('Administrador'), findsOneWidget);
  });

  testWidgets('los chips de acceso rapido rellenan usuario y contraseña', (tester) async {
    final app = await IntegracionAplicacion.construir(
      constructor: const ConstructorAplicacionUT(),
    );

    await tester.pumpWidget(app);
    await tester.pump(const Duration(seconds: 2));

    final chipCliente = find.text('Cliente local (cliente1)');
    expect(chipCliente, findsOneWidget);

    await tester.ensureVisible(chipCliente);
    await tester.pumpAndSettle();
    await tester.tap(chipCliente);
    await tester.pumpAndSettle();

    expect(find.text('cliente1'), findsOneWidget);

    await tester.ensureVisible(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Catálogo'), findsWidgets);
    expect(find.text('Cliente'), findsOneWidget);
  });
}
