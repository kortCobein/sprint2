# Épica 3 — Inventario
**Responsable:** Kurt  
**Historias:** HIST06 Agregar · HIST07 Editar · HIST08 Eliminar producto

## Arquitectura que debes entender

Las tres historias son operaciones administrativas diferentes. Comparten validación de producto, pero cada operación conserva su propio controlador, repositorio y servicio.

```text
Agregar  → ControladorAgregarProducto  → RepositorioRegistroProducto      → ApiRegistroProducto
Editar   → ControladorEditarProducto   → RepositorioActualizacionProducto → ApiActualizacionProducto
Eliminar → ControladorEliminarProducto → RepositorioEliminacionProducto   → ApiEliminacionProducto
```

## Compartido

### `validador_producto.dart`
Valida título, precio, descripción, categoría y URL antes de enviar datos.

Función importante: `validar`.

**SOLID:** **S** solo contiene reglas de validación. **O** puede ampliarse con nuevas reglas sin meter validaciones dentro de cada controlador. Evita duplicar la misma responsabilidad en HIST06 y HIST07.

## HIST06 — Agregar producto

### `controlador_agregar_producto.dart`
Verifica permisos, ejecuta validación, controla carga/error y solicita creación.  
Función importante: `agregar`.

**SOLID:** **S** coordina el caso de uso. **D** recibe `RepositorioRegistroProducto` y `ValidadorProducto`, no crea HTTP.

### `repositorio_registro_producto.dart`
Contrato e implementación para crear productos.  
Función importante: `crear`.

**SOLID:** **I** contrato específico de creación. **D/L** el controlador depende de la abstracción y la implementación puede sustituirse.

### `servicio_registro_producto_http.dart`
Realiza POST `/products` y procesa la respuesta.  
Función importante: `crear`.

**SOLID:** **S** solo HTTP de creación. **L/O** otra implementación puede reemplazarla sin cambiar el controlador.

### `pantalla_agregar_producto.dart`
Captura los datos del formulario y llama al controlador.  
Funciones importantes: `createState`, `build`, `_guardar`, `dispose`.

**SOLID:** **S** UI/formulario; las reglas de permisos y validación profunda quedan en controlador/validador.

## HIST07 — Editar producto

### `controlador_editar_producto.dart`
Valida permisos y datos antes de solicitar una actualización.  
Función importante: `editar`.

**SOLID:** **S** coordina únicamente edición. **D** usa `RepositorioActualizacionProducto`.

### `repositorio_actualizacion_producto.dart`
Contrato e implementación para actualizar un producto.  
Función importante: `actualizar`.

**SOLID:** **I** interfaz específica para PUT. **D/L** mantiene desacoplado al controlador.

### `servicio_actualizacion_producto_http.dart`
Realiza PUT `/products/{id}`.  
Función importante: `actualizar`.

**SOLID:** **S** transporte remoto de actualización. **O/L** sustituible por otro backend.

### `pantalla_editar_producto.dart`
Precarga los datos actuales, permite editarlos y envía la acción al controlador.  
Funciones importantes: `createState`, `initState`, `build`, `_guardar`, `dispose`.

**SOLID:** **S** presentación y captura de datos.

## HIST08 — Eliminar producto

### `controlador_eliminar_producto.dart`
Verifica el rol y solicita eliminación, manteniendo carga/error.  
Función importante: `eliminar`.

**SOLID:** **S** coordina eliminación. **D** recibe `RepositorioEliminacionProducto`.

### `repositorio_eliminacion_producto.dart`
Contrato e implementación para borrar por ID.  
Función importante: `eliminar`.

**SOLID:** **I** contrato mínimo. **D/L** permite probar el controlador sin una API real.

### `servicio_eliminacion_producto_http.dart`
Realiza DELETE `/products/{id}`.  
Función importante: `eliminar`.

**SOLID:** **S** únicamente HTTP destructivo; **L/O** sustituible.

### `dialogo_confirmar_eliminacion.dart`
Pide confirmación antes de continuar con una operación destructiva.  
Función importante: `confirmarEliminacion`.

**SOLID:** **S** solo confirmación visual; no borra nada por sí mismo.

## Cómo explicarlo mañana
1. Muestra que CRUD no está en una mega clase.
2. Cada historia tiene su propio contrato de repositorio.
3. Explica que **I** se ve porque agregar, editar y eliminar no obligan a depender de métodos que no usan.
4. Explica que **D** se ve en los controladores: reciben repositorios.
5. `ValidadorProducto` es compartido porque la misma regla aplica a creación y edición.
