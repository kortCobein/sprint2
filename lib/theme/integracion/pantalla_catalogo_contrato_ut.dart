import 'package:flutter/material.dart';

import '../../core/contratos/carrito.dart';
import '../../core/contratos/productos.dart';
import '../../core/contratos/sesion.dart';
import '../../core/integracion/contenedor_dependencias.dart';
import '../componentes/boton_ut.dart';
import '../componentes/campo_ut.dart';
import '../componentes/chip_filtro_ut.dart';
import '../componentes/dialogo_ut.dart';
import '../componentes/estado_carga_ut.dart';
import '../componentes/estado_error_ut.dart';
import '../componentes/estado_vacio_ut.dart';
import '../componentes/tarjeta_producto_ut.dart';
import '../dimensiones_ut.dart';
import '../pantallas/contenedor_responsive_ut.dart';
import '../pantallas/grilla_adaptativa_ut.dart';

class PantallaCatalogoContratoUT extends StatefulWidget {
  const PantallaCatalogoContratoUT({
    super.key,
    required this.sesion,
    required this.contenedor,
  });

  final SesionAplicacion sesion;
  final ContenedorDependencias contenedor;

  @override
  State<PantallaCatalogoContratoUT> createState() =>
      _PantallaCatalogoContratoUTState();
}

class _PantallaCatalogoContratoUTState
    extends State<PantallaCatalogoContratoUT> {
  List<ProductoAplicacion> _productos = const [];
  List<String> _categorias = const ['Todos'];
  String _categoria = 'Todos';
  bool _cargando = true;
  String? _error;

  CatalogoAplicacion? get _catalogo =>
      widget.contenedor.intentarObtener<CatalogoAplicacion>();
  CategoriasAplicacion? get _categoriasApi =>
      widget.contenedor.intentarObtener<CategoriasAplicacion>();

  @override
  void initState() {
    super.initState();
    _cargarInicial();
  }

  Future<void> _cargarInicial() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final catalogo = _catalogo;
      if (catalogo == null) {
        throw StateError('US03 está inactiva.');
      }

      final resultados = await Future.wait<dynamic>([
        catalogo.listar(),
        if (_categoriasApi != null) _categoriasApi!.listarCategorias(),
      ]);

      _productos = resultados.first as List<ProductoAplicacion>;
      if (resultados.length > 1) {
        _categorias = List<String>.from(resultados[1] as List<String>);
      }
    } catch (error) {
      _error = _limpiarError(error);
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _seleccionarCategoria(String categoria) async {
    setState(() {
      _categoria = categoria;
      _cargando = true;
      _error = null;
    });

    try {
      if (categoria == 'Todos' || _categoriasApi == null) {
        _productos = await _catalogo!.listar();
      } else {
        _productos = await _categoriasApi!.listarPorCategoria(categoria);
      }
    } catch (error) {
      _error = _limpiarError(error);
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _abrirDetalle(ProductoAplicacion productoBase) async {
    var producto = productoBase;
    final detalle =
        widget.contenedor.intentarObtener<DetalleProductoAplicacion>();

    if (detalle != null) {
      try {
        producto = await detalle.obtener(productoBase.id);
      } catch (_) {
        producto = productoBase;
      }
    }

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _DetalleProductoUT(
        producto: producto,
        sesion: widget.sesion,
        puedeEditar:
            widget.contenedor.contiene<EditarProductoAplicacion>(),
        puedeEliminar:
            widget.contenedor.contiene<EliminarProductoAplicacion>(),
        puedeAgregarCarrito:
            widget.contenedor.contiene<AgregarCarritoAplicacion>(),
        alEditar: () async {
          Navigator.of(context).pop();
          await _editar(producto);
        },
        alEliminar: () async {
          Navigator.of(context).pop();
          await _eliminar(producto);
        },
        alAgregar: () async {
          Navigator.of(context).pop();
          await _agregarCarrito(producto);
        },
      ),
    );
  }

  Future<void> _crear() async {
    final contrato =
        widget.contenedor.intentarObtener<CrearProductoAplicacion>();
    if (contrato == null) return;

    final cambio = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _FormularioProductoUT(
          titulo: 'Nuevo producto',
          sesion: widget.sesion,
          crear: contrato,
        ),
      ),
    );

    if (cambio == true) {
      await _cargarInicial();
    }
  }

  Future<void> _editar(ProductoAplicacion producto) async {
    final contrato =
        widget.contenedor.intentarObtener<EditarProductoAplicacion>();
    if (contrato == null) return;

    final cambio = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _FormularioProductoUT(
          titulo: 'Editar producto',
          sesion: widget.sesion,
          producto: producto,
          editar: contrato,
        ),
      ),
    );

    if (cambio == true) {
      await _cargarInicial();
    }
  }

  Future<void> _eliminar(ProductoAplicacion producto) async {
    final contrato =
        widget.contenedor.intentarObtener<EliminarProductoAplicacion>();
    if (contrato == null) return;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => DialogoUT(
        titulo: 'Eliminar producto',
        mensaje: '¿Deseas eliminar “${producto.titulo}”?',
        etiquetaConfirmar: 'Eliminar',
        peligroso: true,
        icono: Icons.delete_outline_rounded,
        alCancelar: () => Navigator.of(context).pop(false),
        alConfirmar: () => Navigator.of(context).pop(true),
      ),
    );

    if (confirmado != true) return;

    try {
      await contrato.eliminar(
        rol: widget.sesion.rol,
        id: producto.id,
      );
      await _cargarInicial();
    } catch (error) {
      if (!mounted) return;
      _mostrarMensaje(_limpiarError(error));
    }
  }

  Future<void> _agregarCarrito(ProductoAplicacion producto) async {
    final contrato =
        widget.contenedor.intentarObtener<AgregarCarritoAplicacion>();
    if (contrato == null) return;

    try {
      await contrato.agregar(
        rol: widget.sesion.rol,
        usuario: widget.sesion.id,
        producto: producto,
      );
      if (mounted) {
        _mostrarMensaje('Producto agregado al carrito.');
      }
    } catch (error) {
      if (mounted) {
        _mostrarMensaje(_limpiarError(error));
      }
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando && _productos.isEmpty) {
      return const EstadoCargaUT(mensaje: 'Cargando catálogo…');
    }

    if (_error != null && _productos.isEmpty) {
      return EstadoErrorUT(
        mensaje: _error!,
        alReintentar: _cargarInicial,
      );
    }

    final puedeCrear = widget.sesion.rol.puedeGestionarProductos &&
        widget.contenedor.contiene<CrearProductoAplicacion>();

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _cargarInicial,
          child: ListView(
            padding: const EdgeInsets.only(
              bottom: DimensionesUT.espacio32 * 3,
            ),
            children: [
              ContenedorResponsiveUT(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: DimensionesUT.espacio20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_categoriasApi != null)
                        Wrap(
                          spacing: DimensionesUT.espacio8,
                          runSpacing: DimensionesUT.espacio8,
                          children: _categorias
                              .map(
                                (categoria) => ChipFiltroUT(
                                  etiqueta: categoria,
                                  seleccionado: _categoria == categoria,
                                  alSeleccionar: (_) =>
                                      _seleccionarCategoria(categoria),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      if (_categoriasApi != null)
                        const SizedBox(height: DimensionesUT.espacio20),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: DimensionesUT.espacio16,
                          ),
                          child: EstadoErrorUT(
                            mensaje: _error!,
                            alReintentar: () =>
                                _seleccionarCategoria(_categoria),
                          ),
                        ),
                      if (_productos.isEmpty)
                        const EstadoVacioUT(
                          titulo: 'Sin productos',
                          mensaje: 'No hay productos para mostrar.',
                        )
                      else
                        GrillaAdaptativaUT(
                          items: _productos
                              .map(
                                (producto) => TarjetaProductoUT(
                                  titulo: producto.titulo,
                                  precio:
                                      '\$${producto.precio.toStringAsFixed(2)}',
                                  categoria: producto.categoria,
                                  descripcion: producto.descripcion,
                                  imagen: Image.network(
                                    producto.imagen,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 42,
                                    ),
                                  ),
                                  alPresionar: () => _abrirDetalle(producto),
                                ),
                              )
                              .toList(growable: false),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (puedeCrear)
          Positioned(
            right: DimensionesUT.espacio20,
            bottom: DimensionesUT.espacio20,
            child: FloatingActionButton.extended(
              onPressed: _crear,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Producto'),
            ),
          ),
      ],
    );
  }
}

class _DetalleProductoUT extends StatelessWidget {
  const _DetalleProductoUT({
    required this.producto,
    required this.sesion,
    required this.puedeEditar,
    required this.puedeEliminar,
    required this.puedeAgregarCarrito,
    required this.alEditar,
    required this.alEliminar,
    required this.alAgregar,
  });

  final ProductoAplicacion producto;
  final SesionAplicacion sesion;
  final bool puedeEditar;
  final bool puedeEliminar;
  final bool puedeAgregarCarrito;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;
  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    final admin = sesion.rol.puedeGestionarProductos;
    final cliente = sesion.rol.puedeUsarCarrito;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          DimensionesUT.espacio20,
          0,
          DimensionesUT.espacio20,
          DimensionesUT.espacio24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 220,
                child: Image.network(
                  producto.imagen,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    size: 58,
                  ),
                ),
              ),
              const SizedBox(height: DimensionesUT.espacio16),
              Text(
                producto.titulo,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: DimensionesUT.espacio8),
              Text(
                '\$${producto.precio.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: DimensionesUT.espacio8),
              Text(producto.categoria),
              const SizedBox(height: DimensionesUT.espacio16),
              Text(producto.descripcion),
              const SizedBox(height: DimensionesUT.espacio24),
              if (cliente && puedeAgregarCarrito)
                BotonUT(
                  etiqueta: 'Agregar al carrito',
                  icono: Icons.add_shopping_cart_rounded,
                  expandido: true,
                  alPresionar: alAgregar,
                ),
              if (admin && puedeEditar) ...[
                BotonUT(
                  etiqueta: 'Editar',
                  icono: Icons.edit_outlined,
                  variante: VarianteBotonUT.secundario,
                  expandido: true,
                  alPresionar: alEditar,
                ),
                const SizedBox(height: DimensionesUT.espacio12),
              ],
              if (admin && puedeEliminar)
                BotonUT(
                  etiqueta: 'Eliminar',
                  icono: Icons.delete_outline_rounded,
                  variante: VarianteBotonUT.peligro,
                  expandido: true,
                  alPresionar: alEliminar,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormularioProductoUT extends StatefulWidget {
  const _FormularioProductoUT({
    required this.titulo,
    required this.sesion,
    this.producto,
    this.crear,
    this.editar,
  });

  final String titulo;
  final SesionAplicacion sesion;
  final ProductoAplicacion? producto;
  final CrearProductoAplicacion? crear;
  final EditarProductoAplicacion? editar;

  @override
  State<_FormularioProductoUT> createState() => _FormularioProductoUTState();
}

class _FormularioProductoUTState extends State<_FormularioProductoUT> {
  late final TextEditingController _titulo;
  late final TextEditingController _precio;
  late final TextEditingController _categoria;
  late final TextEditingController _imagen;
  late final TextEditingController _descripcion;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final producto = widget.producto;
    _titulo = TextEditingController(text: producto?.titulo ?? '');
    _precio = TextEditingController(
      text: producto == null ? '' : producto.precio.toString(),
    );
    _categoria = TextEditingController(text: producto?.categoria ?? '');
    _imagen = TextEditingController(text: producto?.imagen ?? '');
    _descripcion = TextEditingController(text: producto?.descripcion ?? '');
  }

  @override
  void dispose() {
    _titulo.dispose();
    _precio.dispose();
    _categoria.dispose();
    _imagen.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final precio = double.tryParse(_precio.text.trim());
    if (precio == null) {
      setState(() => _error = 'El precio no es válido.');
      return;
    }

    final base = widget.producto;
    final producto = ProductoAplicacion(
      id: base?.id ?? 0,
      titulo: _titulo.text.trim(),
      precio: precio,
      imagen: _imagen.text.trim(),
      categoria: _categoria.text.trim(),
      descripcion: _descripcion.text.trim(),
    );

    setState(() {
      _guardando = true;
      _error = null;
    });

    try {
      if (widget.crear != null) {
        await widget.crear!.crear(
          rol: widget.sesion.rol,
          producto: producto,
        );
      } else if (widget.editar != null) {
        await widget.editar!.editar(
          rol: widget.sesion.rol,
          producto: producto,
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = _limpiarError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: ContenedorResponsiveUT(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DimensionesUT.espacio20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CampoUT(etiqueta: 'Título', controlador: _titulo),
              const SizedBox(height: DimensionesUT.espacio12),
              CampoUT(
                etiqueta: 'Precio',
                controlador: _precio,
                tipoTeclado:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: DimensionesUT.espacio12),
              CampoUT(etiqueta: 'Categoría', controlador: _categoria),
              const SizedBox(height: DimensionesUT.espacio12),
              CampoUT(etiqueta: 'URL de imagen', controlador: _imagen),
              const SizedBox(height: DimensionesUT.espacio12),
              CampoUT(
                etiqueta: 'Descripción',
                controlador: _descripcion,
                maxLineas: 5,
                minLineas: 3,
              ),
              if (_error != null) ...[
                const SizedBox(height: DimensionesUT.espacio16),
                EstadoErrorUT(mensaje: _error!),
              ],
              const SizedBox(height: DimensionesUT.espacio20),
              BotonUT(
                etiqueta: 'Guardar',
                icono: Icons.save_outlined,
                cargando: _guardando,
                expandido: true,
                alPresionar: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _limpiarError(Object error) {
  return error.toString().replaceFirst('Bad state: ', '');
}
