import 'package:flutter_test/flutter_test.dart';
import 'package:sprint_02/core/adaptadores/us01_adaptador.dart';
import 'package:sprint_02/core/autenticacion/autenticacion_local_ut.dart';
import 'package:sprint_02/core/contratos/sesion.dart';
import 'package:sprint_02/core/integracion/contenedor_dependencias.dart';

void main() {
  group('AutenticacionLocalUT', () {
    final casos = <String, ({String clave, int id, RolAplicacion rol})>{
      'admin1': (
        clave: '1',
        id: 1,
        rol: RolAplicacion.administrador,
      ),
      'admin2': (
        clave: '2',
        id: 2,
        rol: RolAplicacion.administrador,
      ),
      'auditor1': (
        clave: '3',
        id: 3,
        rol: RolAplicacion.auditor,
      ),
      'cliente1': (
        clave: '4',
        id: 4,
        rol: RolAplicacion.cliente,
      ),
      'cliente2': (
        clave: '5',
        id: 5,
        rol: RolAplicacion.cliente,
      ),
      'cliente3': (
        clave: '6',
        id: 6,
        rol: RolAplicacion.cliente,
      ),
    };

    for (final entrada in casos.entries) {
      test('${entrada.key}/${entrada.value.clave} inicia sesion', () async {
        final auth = AutenticacionLocalUT();

        final sesion = await auth.iniciarSesion(
          usuario: entrada.key,
          contrasena: entrada.value.clave,
        );

        expect(sesion.id, entrada.value.id);
        expect(sesion.usuario, entrada.key);
        expect(sesion.rol, entrada.value.rol);
      });
    }

    test('rechaza credenciales incorrectas', () async {
      final auth = AutenticacionLocalUT();

      expect(
        () => auth.iniciarSesion(usuario: 'admin1', contrasena: '6'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('US01 Adaptador Hibrido', () {
    test('registra AutenticacionAplicacion en el contenedor', () {
      final contenedor = ContenedorDependencias();
      final modulo = crearModulo();
      modulo.registrarDependencias(contenedor);

      expect(contenedor.contiene<AutenticacionAplicacion>(), isTrue);
      final auth = contenedor.obtener<AutenticacionAplicacion>();
      expect(auth, isNotNull);
    });

    test('permite login local para cuentas conocidas', () async {
      final contenedor = ContenedorDependencias();
      final modulo = crearModulo();
      modulo.registrarDependencias(contenedor);

      final auth = contenedor.obtener<AutenticacionAplicacion>();
      final sesion = await auth.iniciarSesion(usuario: 'admin1', contrasena: '1');

      expect(sesion.id, 1);
      expect(sesion.usuario, 'admin1');
      expect(sesion.rol, RolAplicacion.administrador);
    });

    test('permite login remoto con FakeStore johnd (admin)', () async {
      final contenedor = ContenedorDependencias();
      final modulo = crearModulo();
      modulo.registrarDependencias(contenedor);

      final auth = contenedor.obtener<AutenticacionAplicacion>();
      final sesion = await auth.iniciarSesion(usuario: 'johnd', contrasena: 'm38rmF\$');

      expect(sesion.id, 1);
      expect(sesion.usuario, 'johnd');
      expect(sesion.rol, RolAplicacion.administrador);
    });

    test('permite login remoto con FakeStore kevinryan (auditor)', () async {
      final contenedor = ContenedorDependencias();
      final modulo = crearModulo();
      modulo.registrarDependencias(contenedor);

      final auth = contenedor.obtener<AutenticacionAplicacion>();
      final sesion = await auth.iniciarSesion(usuario: 'kevinryan', contrasena: 'kev02937@');

      expect(sesion.id, 3);
      expect(sesion.usuario, 'kevinryan');
      expect(sesion.rol, RolAplicacion.auditor);
    });

    test('permite login remoto con FakeStore donero (cliente)', () async {
      final contenedor = ContenedorDependencias();
      final modulo = crearModulo();
      modulo.registrarDependencias(contenedor);

      final auth = contenedor.obtener<AutenticacionAplicacion>();
      final sesion = await auth.iniciarSesion(usuario: 'donero', contrasena: 'ewedon');

      expect(sesion.id, 4);
      expect(sesion.usuario, 'donero');
      expect(sesion.rol, RolAplicacion.cliente);
    });
  });
}
