# Arquitectura de integración

El núcleo evita que `main.dart` conozca las 12 User Stories.

Flujo:

```text
main.dart
   ↓
IntegracionAplicacion
   ↓
registro_historias.g.dart
   ↓
ModuloHistoria
   ↓
adaptadores us01 ... us12
   ↓
features congeladas
```

La capa visual se conecta mediante `ConstructorAplicacion`:

```text
core contratos ──→ theme
       ↑
   adaptadores
       ↑
    features
```

## Regla de activación

```text
ACTIVA = HABILITADA_MANUALMENTE
         && ADAPTADOR_SANO
         && DEPENDENCIAS_ACTIVAS
```

La configuración vive en:

`tool/configuracion_historias.dart`

El registro se regenera con:

```bash
dart run tool/verificar_historias.dart
```

Una historia configurada en `false` nunca es reactivada automáticamente.

## Dependencias

- US02 → US01
- US04 → US03
- US05 → US01 + US03
- US06 → US01 + US03
- US07 → US01 + US03 + US06
- US08 → US01
- US09 → US01 + US03
- US10 → US01 + US09
- US11 → US01
- US12 → US01

US01 y US03 pueden funcionar como raíces independientes.

## Composición

`ContenedorDependencias` es el composition root. Los adaptadores registran
contratos de aplicación sin obligar a theme a importar controladores o
repositorios concretos.

Contratos de dominio:

- `AutenticacionAplicacion`
- `CierreSesionAplicacion`
- `CatalogoAplicacion`
- `CategoriasAplicacion`
- `DetalleProductoAplicacion`
- `CrearProductoAplicacion`
- `EditarProductoAplicacion`
- `EliminarProductoAplicacion`
- `AgregarCarritoAplicacion`
- `GestionCarritoAplicacion`
- `UsuariosAplicacion`
- `AuditoriaCarritosAplicacion`

## main.dart final

Cuando la implementación visual de `ConstructorAplicacion` esté conectada,
`main.dart` debe reducirse a inicialización + composición + `runApp`, sin
construir repositorios, controladores, rutas ni dependencias manualmente.
