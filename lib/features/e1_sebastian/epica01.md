# Épica 1 — Autenticación
**Responsable:** Sebastián Mendoza Montoya  
**Historias:** HIST01 Login y asignación de perfiles · HIST02 Logout y limpieza de credenciales

## Arquitectura que debes entender

La épica separa interfaz, estado, reglas de negocio, almacenamiento y HTTP. La pantalla no llama a la API directamente: la acción baja por controlador → repositorio → contratos concretos y el resultado regresa hacia la interfaz.

```text
HIST01
UI → ControladorInicioSesion → RepositorioAutenticacion
                               ├─ ApiAutenticacion
                               ├─ AlmacenSesion
                               └─ AsignadorPerfiles

HIST02
UI → ControladorCierreSesion → RepositorioCierreSesion
                              ├─ AlmacenCredenciales
                              └─ LimpiadorEstadoMemoria
```

## HIST01 — Login

### `sesion_usuario.dart`
Representa una sesión válida. Guarda ID, usuario, datos personales, rol y token.  
Funciones importantes: `nombreVisible`, `aJson`, `SesionUsuario.desdeJson`.

**SOLID:** **S** porque solo modela la sesión; no hace HTTP ni UI. La serialización permanece junto al modelo porque transforma el propio estado del objeto.

### `excepciones_autenticacion.dart`
Define errores diferenciados para credenciales inválidas, red y autenticación general.  
Funciones importantes: `toString`.

**SOLID:** **S** porque cada excepción representa una causa concreta. **O** porque pueden añadirse nuevos errores sin reescribir el controlador.

### `servicio_autenticacion_http.dart`
Único archivo que conoce la comunicación HTTP y la conectividad.  
Funciones importantes: `iniciarSesion`, `buscarUsuario`, `hayConexion`, `_asegurarConexion`, `cerrar`.

**SOLID:** **S** separa transporte HTTP del resto. **I** usa contratos pequeños (`ApiAutenticacion`, `VerificadorConexion`). **D** permite que el repositorio dependa del contrato y no de `http.Client`. **L/O** permiten sustituir esta implementación por una falsa o por otro backend.

### `almacen_sesion_segura.dart`
Abstrae guardar, leer y limpiar la sesión persistente.  
Funciones importantes: `guardar`, `leer`, `limpiar`.

**SOLID:** **I** porque el contrato solo expone las operaciones necesarias. **D** porque la autenticación recibe `AlmacenSesion`. **L/O** porque puede cambiarse el mecanismo de almacenamiento sin modificar el repositorio.

### `repositorio_autenticacion.dart`
Coordina autenticación, recuperación del usuario, asignación de rol y guardado de sesión.  
Funciones importantes: `iniciarSesion`, `restaurarSesion`.

**SOLID:** **S** coordina el caso de uso, no dibuja UI ni implementa HTTP. **D** depende de `ApiAutenticacion`, `AlmacenSesion` y `AsignadorPerfiles`. **L** permite sustituir `RepositorioAutenticacionImpl` por una implementación de prueba.

### `controlador_inicio_sesion.dart`
Mantiene el estado que observa la pantalla: sesión, carga y error.  
Funciones importantes: `restaurarSesion`, `iniciarSesion`, `limpiarError`.

**SOLID:** **S** concentra estado de presentación. **D** recibe `RepositorioAutenticacion` en lugar de crear servicios concretos.

### `formulario_inicio_sesion.dart`
Captura usuario/contraseña, valida el formulario y dispara el controlador.  
Funciones importantes: `createState`, `build`, `_enviar`, `dispose`.

**SOLID:** **S** se limita a interacción de formulario. La regla de negocio queda fuera del widget.

### `pantalla_inicio_sesion.dart`
Compone visualmente la pantalla completa de acceso y reutiliza el formulario.  
Función importante: `build`.

**SOLID:** **S** porque su responsabilidad es composición visual.

## HIST01 — Asignación de perfiles

### `asignador_perfiles.dart`
Contiene la regla ID → rol. Los IDs 1 y 2 son Administrador, 3 Auditor y el resto Cliente.  
Función importante: `asignar`.

**SOLID:** **S** la regla vive aislada. **I** `AsignadorPerfiles` tiene un solo método. **D** el repositorio consume la abstracción. **L/O** otra política puede sustituir a `AsignadorPerfilesPorId` sin cambiar el login.

## HIST02 — Logout

### `repositorio_cierre_sesion.dart`
Coordina borrar credenciales y limpiar estado sensible en memoria.  
Función importante: `cerrarSesion`.

**SOLID:** **D** depende de abstracciones de limpieza. **S** únicamente representa el caso de uso de cierre.

### `controlador_cierre_sesion.dart`
Mantiene el estado de cierre y errores para la interfaz.  
Funciones importantes: `cerrarSesion`, `_cambiarEstado`.

**SOLID:** **S** controla estado. **D** recibe `RepositorioCierreSesion`.

### `excepcion_cierre_sesion.dart`
Representa un fallo del proceso de logout.  
Función importante: `toString`.

**SOLID:** **S** encapsula únicamente ese tipo de error.

### `boton_cerrar_sesion.dart`
Botón visual que solicita el logout y después permite a la capa exterior decidir la navegación.  
Funciones importantes: `build`, `_cerrarSesionYSalir`.

**SOLID:** **S** interacción visual. La lógica sensible permanece en controlador/repositorio.

## HIST02 — Limpieza de credenciales

### `almacen_credenciales_seguras.dart`
Contrato e implementación para eliminar credenciales persistentes.  
Función importante: `limpiarCredenciales`.

**SOLID:** **I**, **D** y **L**: contrato mínimo, recibido desde fuera y sustituible.

### `limpiador_estado_memoria.dart`
Permite que HIST02 limpie carrito, caché u otro estado sin importar directamente esas épicas.  
Función importante: `limpiar`.

**SOLID:** aquí se ve especialmente **D**: logout depende de `LimpiadorEstadoMemoria`, no de una clase concreta de carrito. También **I** porque el contrato tiene una sola operación.

## Cómo explicarlo mañana
1. Empieza por `controlador_inicio_sesion.dart`.
2. Sigue hacia `repositorio_autenticacion.dart`.
3. Muestra que el repositorio recibe tres abstracciones.
4. Explica `asignador_perfiles.dart` como regla aislada.
5. En HIST02 muestra que el logout limpia persistencia y memoria sin conocer otras épicas.
