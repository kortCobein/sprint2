# Épica 5 — Auditoría
**Responsable:** Julio  
**Historias:** HIST11 Listar usuarios · HIST12 Histórico global de carritos

## Arquitectura que debes entender

Toda la épica es de lectura. HIST11 consulta usuarios. HIST12 consulta carritos y puede enriquecer los `productId` con títulos usando un contrato independiente.

```text
HIST11
Pantalla → ControladorUsuarios → RepositorioUsuarios → ApiUsuarios

HIST12
Pantalla → ControladorCarritosAuditoria → RepositorioCarritosAuditoria → ApiCarritosAuditoria
                                      ↓
                              EnriquecedorCarritos
                                      ↓
                              ProveedorTitulosProducto
```

## HIST11 — Listar usuarios

### `modelo_usuario.dart`
Define `DireccionUsuario` y `UsuarioTienda`, incluyendo datos anidados de la API.  
Función importante: `nombreCompleto` y constructores de mapeo.

**SOLID:** **S** modela únicamente usuarios/direcciones.

### `servicio_usuarios_http.dart`
Consulta GET `/users`.  
Función importante: `obtenerUsuarios`.

**SOLID:** **S** solo HTTP de usuarios. **I/D** implementa `ApiUsuarios`, que puede sustituirse.

### `repositorio_usuarios.dart`
Convierte la respuesta remota en `UsuarioTienda`.  
Función importante: `obtenerUsuarios`.

**SOLID:** **I** contrato de lectura específico. **D** controlador depende del repositorio abstracto. **L** implementación reemplazable.

### `controlador_usuarios.dart`
Valida permiso de auditoría, mantiene carga/error y solicita usuarios.  
Función importante: `cargar`.

**SOLID:** **S** estado y coordinación. **D** recibe `RepositorioUsuarios`.

### `pantalla_usuarios.dart`
Representa la lista de usuarios y estados de carga/error.  
Función importante: `build`.

**SOLID:** **S** solo presentación.

## HIST12 — Histórico de carritos

### `modelo_carrito_auditoria.dart`
Representa carritos y artículos del histórico. Permite crear copias enriquecidas con títulos.  
Funciones importantes: `conTitulo`, `conProductos`.

**SOLID:** **S** solo modelo de auditoría.

### `servicio_carritos_auditoria_http.dart`
Consulta GET `/carts`.  
Función importante: `obtenerCarritos`.

**SOLID:** **S** solo comunicación HTTP. **I/D/L** gracias al contrato `ApiCarritosAuditoria`.

### `proveedor_titulos_producto.dart`
Contrato mínimo para obtener un mapa `productId → título`.

Función importante: `obtenerTitulos`.

**SOLID:** este archivo demuestra especialmente **I** y **D**. HIST12 no necesita importar el catálogo completo: solo solicita los títulos que requiere. Cualquier fuente que entregue ese mapa puede sustituirse (**L**).

### `enriquecedor_carritos.dart`
Cruza los IDs de productos con sus títulos sin conocer cómo se obtuvieron.  
Función importante: `agregarTitulos`.

**SOLID:** **S** una única transformación. **D** depende de `ProveedorTitulosProducto`, no de Leonel ni de una API concreta.

### `repositorio_carritos_auditoria.dart`
Obtiene los carritos remotos y coordina el enriquecimiento.  
Función importante: `obtener`.

**SOLID:** **S** coordina el caso de lectura. **D** recibe `ApiCarritosAuditoria` y `EnriquecedorCarritos`. **L/O** permite cambiar cualquiera de esas piezas.

### `controlador_carritos_auditoria.dart`
Valida permisos y mantiene carga/error/lista de carritos.  
Función importante: `cargar`.

**SOLID:** **S** estado de presentación. **D** recibe el repositorio.

### `pantalla_carritos_auditoria.dart`
Muestra carritos y sus artículos sin ofrecer modificaciones.  
Función importante: `build`.

**SOLID:** **S** solo UI de lectura.

## Cómo explicarlo mañana
1. HIST11 es una cadena de lectura simple.
2. HIST12 agrega un paso de enriquecimiento.
3. Enseña `ProveedorTitulosProducto`: evita que Julio dependa directamente del catálogo de Leonel.
4. Ese punto es un ejemplo claro de **I + D + L**.
5. Toda la épica conserva modo lectura; no contiene creación, edición ni eliminación.
