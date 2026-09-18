# Adaptadores de historias

Esta carpeta es la frontera entre `core` y el código congelado de `features`.

Cada archivo `usXX_adaptador.dart` debe:

1. importar únicamente los archivos necesarios de su User Story;
2. construir repositorios y controladores de esa historia;
3. implementar `ModuloHistoria`;
4. declarar sus dependencias mediante `dependencias`;
5. registrar contratos compartidos en `ContenedorDependencias` cuando otras historias los necesiten;
6. exponer sus rutas mediante `RutaHistoria`;
7. exportar una función superior con esta firma:

```dart
ModuloHistoria crearModulo() => ModuloUsXX();
```

No se modifica el código de `lib/features` para adaptarlo al núcleo.

## Activación selectiva

La activación manual se controla en:

`tool/configuracion_historias.dart`

El registro de imports se genera con:

```bash
dart run tool/verificar_historias.dart
```

El generador solo importa adaptadores que cumplan simultáneamente:

```text
HABILITADA && SANA && DEPENDENCIAS_ACTIVAS
```

Una historia marcada manualmente como `false` nunca puede ser reactivada por el verificador.

Esto permite que una historia rota o deshabilitada no sea importada por el punto de composición.
