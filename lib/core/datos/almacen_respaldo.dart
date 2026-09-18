import '../contratos/auditoria.dart';
import '../contratos/productos.dart';

/// Respaldo local para demostración cuando Fake Store API no responde.
///
/// La app siempre intenta usar la API primero. Este almacén evita que una caída
/// externa deje vacías las pantallas del sprint.
final class AlmacenRespaldo {
  final List<ProductoAplicacion> _productos = <ProductoAplicacion>[
    const ProductoAplicacion(
      id: 1,
      titulo: 'Mochila urbana UT',
      precio: 699.00,
      imagen: '',
      categoria: 'accesorios',
      descripcion: 'Mochila resistente para uso diario y universitario.',
    ),
    const ProductoAplicacion(
      id: 2,
      titulo: 'Audífonos inalámbricos',
      precio: 899.00,
      imagen: '',
      categoria: 'electronica',
      descripcion: 'Audífonos Bluetooth con estuche de carga.',
    ),
    const ProductoAplicacion(
      id: 3,
      titulo: 'Sudadera institucional',
      precio: 549.00,
      imagen: '',
      categoria: 'ropa',
      descripcion: 'Sudadera unisex de algodón para clima fresco.',
    ),
    const ProductoAplicacion(
      id: 4,
      titulo: 'Smartwatch deportivo',
      precio: 1299.00,
      imagen: '',
      categoria: 'electronica',
      descripcion: 'Reloj inteligente con monitoreo de actividad.',
    ),
    const ProductoAplicacion(
      id: 5,
      titulo: 'Termo de acero',
      precio: 329.00,
      imagen: '',
      categoria: 'accesorios',
      descripcion: 'Termo reutilizable de 750 ml.',
    ),
    const ProductoAplicacion(
      id: 6,
      titulo: 'Playera tecnológica',
      precio: 299.00,
      imagen: '',
      categoria: 'ropa',
      descripcion: 'Playera de algodón con diseño tecnológico.',
    ),
  ];

  final List<UsuarioAplicacion> _usuarios = <UsuarioAplicacion>[
    const UsuarioAplicacion(
      id: 1,
      usuario: 'admin1',
      correo: 'admin1@utsjr.local',
      telefono: '4270000001',
      nombreCompleto: 'Administrador 1',
      direccion: DireccionAplicacion(
        ciudad: 'San Juan del Río',
        calle: 'UTSJR',
        numero: 1,
        cp: '76800',
        latitud: '',
        longitud: '',
      ),
    ),
    const UsuarioAplicacion(
      id: 2,
      usuario: 'admin2',
      correo: 'admin2@utsjr.local',
      telefono: '4270000002',
      nombreCompleto: 'Administrador 2',
      direccion: DireccionAplicacion(
        ciudad: 'San Juan del Río',
        calle: 'UTSJR',
        numero: 2,
        cp: '76800',
        latitud: '',
        longitud: '',
      ),
    ),
    const UsuarioAplicacion(
      id: 3,
      usuario: 'auditor1',
      correo: 'auditor1@utsjr.local',
      telefono: '4270000003',
      nombreCompleto: 'Auditor 1',
      direccion: DireccionAplicacion(
        ciudad: 'San Juan del Río',
        calle: 'UTSJR',
        numero: 3,
        cp: '76800',
        latitud: '',
        longitud: '',
      ),
    ),
    const UsuarioAplicacion(
      id: 4,
      usuario: 'cliente1',
      correo: 'cliente1@utsjr.local',
      telefono: '4270000004',
      nombreCompleto: 'Cliente 1',
      direccion: DireccionAplicacion(
        ciudad: 'San Juan del Río',
        calle: 'UTSJR',
        numero: 4,
        cp: '76800',
        latitud: '',
        longitud: '',
      ),
    ),
    const UsuarioAplicacion(
      id: 5,
      usuario: 'cliente2',
      correo: 'cliente2@utsjr.local',
      telefono: '4270000005',
      nombreCompleto: 'Cliente 2',
      direccion: DireccionAplicacion(
        ciudad: 'San Juan del Río',
        calle: 'UTSJR',
        numero: 5,
        cp: '76800',
        latitud: '',
        longitud: '',
      ),
    ),
    const UsuarioAplicacion(
      id: 6,
      usuario: 'cliente3',
      correo: 'cliente3@utsjr.local',
      telefono: '4270000006',
      nombreCompleto: 'Cliente 3',
      direccion: DireccionAplicacion(
        ciudad: 'San Juan del Río',
        calle: 'UTSJR',
        numero: 6,
        cp: '76800',
        latitud: '',
        longitud: '',
      ),
    ),
  ];

  List<ProductoAplicacion> listarProductos() =>
      List<ProductoAplicacion>.unmodifiable(_productos);

  ProductoAplicacion? obtenerProducto(int id) {
    for (final producto in _productos) {
      if (producto.id == id) return producto;
    }
    return null;
  }

  void reemplazarProductos(List<ProductoAplicacion> productos) {
    if (productos.isEmpty) return;
    _productos
      ..clear()
      ..addAll(productos);
  }

  ProductoAplicacion crearProducto(ProductoAplicacion producto) {
    final siguienteId = _productos.fold<int>(
          0,
          (mayor, actual) => actual.id > mayor ? actual.id : mayor,
        ) +
        1;
    final creado = producto.copiarCon(id: siguienteId);
    _productos.add(creado);
    return creado;
  }

  ProductoAplicacion guardarProducto(ProductoAplicacion producto) {
    final indice = _productos.indexWhere((actual) => actual.id == producto.id);
    if (indice >= 0) {
      _productos[indice] = producto;
    } else {
      _productos.add(producto);
    }
    return producto;
  }

  void eliminarProducto(int id) {
    _productos.removeWhere((producto) => producto.id == id);
  }

  List<String> listarCategorias() {
    final categorias = _productos.map((producto) => producto.categoria).toSet();
    return categorias.toList(growable: false)..sort();
  }

  List<ProductoAplicacion> listarPorCategoria(String categoria) {
    return _productos
        .where((producto) => producto.categoria == categoria)
        .toList(growable: false);
  }

  List<UsuarioAplicacion> listarUsuarios() =>
      List<UsuarioAplicacion>.unmodifiable(_usuarios);

  List<CarritoAuditoriaAplicacion> listarCarritosAuditoria() {
    String? titulo(int id) => obtenerProducto(id)?.titulo;
    return <CarritoAuditoriaAplicacion>[
      CarritoAuditoriaAplicacion(
        id: 1,
        usuarioId: 4,
        fecha: DateTime(2026, 9, 18, 9, 15),
        productos: <ArticuloAuditoriaAplicacion>[
          ArticuloAuditoriaAplicacion(
            productoId: 1,
            cantidad: 1,
            titulo: titulo(1),
          ),
          ArticuloAuditoriaAplicacion(
            productoId: 2,
            cantidad: 2,
            titulo: titulo(2),
          ),
        ],
      ),
      CarritoAuditoriaAplicacion(
        id: 2,
        usuarioId: 5,
        fecha: DateTime(2026, 9, 18, 10, 40),
        productos: <ArticuloAuditoriaAplicacion>[
          ArticuloAuditoriaAplicacion(
            productoId: 5,
            cantidad: 1,
            titulo: titulo(5),
          ),
        ],
      ),
    ];
  }
}
