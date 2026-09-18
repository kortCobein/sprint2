/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'package:flutter/material.dart';
import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../../e2_leonel/hist03_catalogo_general/producto.dart';
import 'controlador_editar_producto.dart';

class PantallaEditarProducto extends StatefulWidget {
  const PantallaEditarProducto({super.key,required this.controlador,required this.rol,required this.producto});
  final ControladorEditarProducto controlador;
  final RolUsuario rol;
  final Producto producto;
  /// Responsabilidad única: Interfaz: Crea el estado asociado al widget y mantiene separada la configuración de su estado mutable.
  @override State<PantallaEditarProducto> createState()=>_PantallaEditarProductoState();
}
class _PantallaEditarProductoState extends State<PantallaEditarProducto>{
  late final TextEditingController titulo,precio,descripcion,imagen,categoria;
  /// Responsabilidad única: Interfaz: Inicializa el estado y prepara los datos requeridos por la pantalla.
  @override
  void initState() {
    super.initState();
    final producto = widget.producto;
    titulo = TextEditingController(text: producto.titulo);
    precio = TextEditingController(text: producto.precio.toStringAsFixed(2));
    descripcion = TextEditingController(text: producto.descripcion);
    imagen = TextEditingController(text: producto.imagen);
    categoria = TextEditingController(text: producto.categoria);
  }
  /// Responsabilidad única: Libera controladores y recursos cuando el widget deja de utilizarse.
  @override
  void dispose() {
    for (final controlador in [titulo, precio, descripcion, imagen, categoria]) {
      controlador.dispose();
    }
    super.dispose();
  }
  /// Responsabilidad única: Interfaz: Construye la interfaz de este componente sin ejecutar directamente reglas de negocio ni llamadas HTTP.
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:widget.controlador,builder:(context,_){
    if(!widget.rol.puedeGestionarProductos)return const Center(child:Text('Acceso restringido'));
    return ListView(padding:const EdgeInsets.all(20),children:[
      TextField(controller:titulo,decoration:const InputDecoration(labelText:'Título')),const SizedBox(height:12),
      TextField(controller:precio,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Precio')),const SizedBox(height:12),
      TextField(controller:categoria,decoration:const InputDecoration(labelText:'Categoría')),const SizedBox(height:12),
      TextField(controller:imagen,decoration:const InputDecoration(labelText:'URL de imagen')),const SizedBox(height:12),
      TextField(controller:descripcion,maxLines:4,decoration:const InputDecoration(labelText:'Descripción')),
      if(widget.controlador.error!=null)...[const SizedBox(height:12),Text(widget.controlador.error!)],
      const SizedBox(height:20),FilledButton(onPressed:widget.controlador.cargando?null:_guardar,child:Text(widget.controlador.cargando?'Guardando...':'Guardar cambios')),
    ]);
  });
  /// Responsabilidad única: Guarda los datos recibidos en el almacenamiento correspondiente.
  Future<void> _guardar() async {
    final p=widget.producto.copiarCon(titulo:titulo.text.trim(),precio:double.tryParse(precio.text.trim())??0,categoria:categoria.text.trim(),imagen:imagen.text.trim(),descripcion:descripcion.text.trim());
    final actualizado=await widget.controlador.editar(widget.rol,p);if(!mounted||actualizado==null)return;Navigator.of(context).pop(actualizado);
  }
}
