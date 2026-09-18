# Épica 2 — Catálogo
**Responsable:** Leonel  
**Historias:** HIST03 Catálogo general · HIST04 Filtro por categoría · HIST05 Detalle de producto

## Arquitectura que debes entender

Las tres historias son de lectura. Cada una separa pantalla/controlador de repositorio y servicio HTTP. Los archivos en `compartido` solo coordinan elementos que pertenecen a más de una historia de esta misma épica.

```text
HIST03: UI → ControladorCatalogo → RepositorioCatalogo → ApiCatalogo
HIST04: UI → ControladorFiltroCategorias → RepositorioCategorias → ApiCategorias
HIST05: UI → ControladorDetalleProducto → RepositorioDetalleProducto → ApiDetalleProducto
```

## Compartido

### `pantalla_catalogo_con_filtros.dart`
Compone HIST03 e HIST04: muestra selector de categorías y catálogo en una sola vista sin duplicar la lógica de ambos controladores.

**SOLID:** **S** porque solo compone módulos existentes; no consulta HTTP. **O** porque se puede cambiar esta composición sin modificar las historias internas.

## HIST03 — Catálogo general

### `controlador_catalogo.dart`
Mantiene lista de productos, carga y error.  
Funciones importantes: `cargar`, `limpiar` y getters de estado.

**SOLID:** **S** controla estado de catálogo. **D** recibe `RepositorioCatalogo`, no crea un servicio HTTP.

### `repositorio_catalogo.dart`
Define `RepositorioCatalogo` e implementa el mapeo entre datos de API y productos del dominio.  
Función importante: `obtenerProductos`.

**SOLID:** **I** contrato pequeño de lectura. **D** el controlador depende de este contrato. **L** `RepositorioCatalogoImpl` puede sustituirse por un repositorio falso. **S** el mapeo de datos queda fuera de la UI.

### `servicio_catalogo_http.dart`
Realiza GET `/products`, valida respuesta, timeout y formato.  
Función importante: `obtenerProductos`.

**SOLID:** **S** solo transporte remoto. **I/D** implementa `ApiCatalogo`, permitiendo sustituir HTTP durante pruebas.

### `pantalla_catalogo.dart`
Representa visualmente los estados del catálogo: carga, error, vacío y productos.  
Función importante: `build`.

**SOLID:** **S** exclusivamente presentación.

### `tarjeta_producto.dart`
Componente visual reutilizable para un producto.  
Función importante: `build`.

**SOLID:** **S** representa un producto; no contiene reglas de consulta.

## HIST04 — Filtrar por categoría

### `controlador_filtro_categorias.dart`
Mantiene categorías, categoría seleccionada, productos filtrados, carga y error.  
Funciones importantes: `cargarCategorias`, `seleccionar`.

**SOLID:** **S** concentra estado del filtro. **D** recibe `RepositorioCategorias`.

### `repositorio_categorias.dart`
Abstrae obtener categorías y obtener productos de una categoría.  
Funciones importantes: `obtenerCategorias`, `filtrar`.

**SOLID:** **I** expone únicamente operaciones de filtrado. **D/L** desacopla al controlador de la fuente HTTP y permite sustituirla.

### `servicio_categorias_http.dart`
Consume `/products/categories` y `/products/category/{categoria}`.  
Funciones importantes: `obtenerCategorias`, `obtenerProductosPorCategoria`, `_lista`.

**SOLID:** **S** solo comunicación remota. **L/O** puede reemplazarse por otra implementación que respete `ApiCategorias`.

### `selector_categorias.dart`
Componente visual que permite elegir la categoría.  
Función importante: `build`.

**SOLID:** **S** únicamente interacción/presentación del selector.

## HIST05 — Detalle de producto

### `controlador_detalle_producto.dart`
Mantiene el producto seleccionado, carga y error.  
Función importante: `cargar`.

**SOLID:** **S** estado del detalle. **D** recibe el repositorio.

### `repositorio_detalle_producto.dart`
Contrato e implementación para obtener un producto por ID.  
Función importante: `obtener`.

**SOLID:** **I**, **D** y **L**: contrato mínimo y sustituible.

### `servicio_detalle_producto_http.dart`
Consume GET `/products/{id}` y devuelve la respuesta remota.  
Función importante: `obtener`.

**SOLID:** **S** transporte HTTP aislado; **L/O** permite cambiar la fuente remota.

### `pantalla_detalle_producto.dart`
Muestra imagen, título, precio, categoría y descripción. Expone callbacks para acciones que otra épica pueda integrar sin meter aquí su lógica.  
Función importante: `build`.

**SOLID:** **S** presentación. **O** admite nuevas acciones por callbacks sin convertir la pantalla en inventario o carrito. **D** la vista no importa implementaciones concretas de esas funciones.

## Cómo explicarlo mañana
1. HIST03: pantalla → controlador → repositorio → servicio.
2. HIST04 repite el patrón, pero su responsabilidad es filtrar.
3. HIST05 repite el patrón para un producto.
4. Enseña `pantalla_catalogo_con_filtros.dart` como composición, no como duplicación de lógica.
5. Señala que HTTP nunca vive dentro de los widgets.
