# Épica 4 — Carrito
**Responsable:** Ariel  
**Historias:** HIST09 Agregar al carrito · HIST10 Gestionar carrito

## Arquitectura que debes entender

La épica separa el estado local del carrito de las operaciones remotas. HIST09 crea/suma productos; HIST10 modifica cantidades o elimina.

```text
                 EstadoCarrito + LineaCarrito
                       ↑                ↑
HIST09 ControladorAgregarCarrito       │
          ↓                            │
RepositorioAgregarCarrito → API POST   │

HIST10 ControladorGestionCarrito ──────┘
          ↓
RepositorioGestionCarrito → API PUT / DELETE
```

## Compartido

### `linea_carrito.dart`
Representa una línea: producto + cantidad. Calcula subtotal y genera el JSON para la API.  
Funciones importantes: `subtotal`, `copiarCon`, `aJsonApi`.

**SOLID:** **S** solo modela una línea del carrito.

### `estado_carrito.dart`
Mantiene las líneas activas y el ID remoto, calcula total y permite reiniciar el carrito.  
Funciones importantes: `establecer`, `asignarIdRemoto`, `reiniciar` y getters de `lineas`, `vacio`, `total`.

**SOLID:** **S** centraliza estado local; no realiza HTTP. Esto permite que HIST09 e HIST10 compartan datos sin duplicar lógica.

## HIST09 — Agregar al carrito

### `controlador_agregar_carrito.dart`
Valida rol/cantidad, evita duplicados sumando cantidades, sincroniza el POST y actualiza estado local.  
Función importante: `agregar`.

**SOLID:** **S** coordina el caso de agregar. **D** recibe `RepositorioAgregarCarrito` y `EstadoCarrito`.

### `repositorio_agregar_carrito.dart`
Contrato e implementación para crear el carrito remoto.  
Función importante: `crear`.

**SOLID:** **I** contrato exclusivo de creación. **D/L** permite sustituir la API real.

### `servicio_agregar_carrito_http.dart`
Realiza POST `/carts`.  
Función importante: `crear`.

**SOLID:** **S** HTTP de creación; **L/O** sustituible.

## HIST10 — Gestionar carrito

### `controlador_gestion_carrito.dart`
Modifica cantidades, elimina líneas, decide cuándo actualizar o borrar el carrito remoto y conserva el estado local.  
Funciones importantes: `cambiarCantidad`, `quitar`, `_guardar`.

**SOLID:** **S** coordina gestión. **D** recibe `RepositorioGestionCarrito` y `EstadoCarrito`.

### `repositorio_gestion_carrito.dart`
Contrato para `actualizar` y `eliminar` el carrito remoto.

**SOLID:** **I** contiene únicamente operaciones necesarias por HIST10. **D/L** desacopla el controlador de HTTP.

### `servicio_gestion_carrito_http.dart`
Realiza PUT y DELETE sobre `/carts/{id}`.  
Funciones importantes: `actualizar`, `eliminar`.

**SOLID:** **S** transporte remoto; **O/L** otra implementación puede reemplazarlo.

### `pantalla_carrito.dart`
Muestra líneas, cantidades, total y acciones de modificación/eliminación.  
Función importante: `build`.

**SOLID:** **S** exclusivamente presentación; utiliza controlador/estado para la lógica.

## Cómo explicarlo mañana
1. Explica primero `EstadoCarrito`: es la memoria local común.
2. HIST09 agrega y sincroniza.
3. HIST10 reutiliza el mismo estado para modificar/eliminar.
4. Señala que las llamadas HTTP están aisladas en servicios.
5. **I** se ve claramente porque POST está separado de PUT/DELETE.
