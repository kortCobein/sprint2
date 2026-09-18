/// Épica 3 - Inventario.
/// Código reorganizado desde US06-US08 del repositorio del equipo.

import 'package:flutter/material.dart';
import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../../e2_leonel/hist03_catalogo_general/producto.dart';
import 'controlador_agregar_producto.dart';

/// Formulario funcional de US06. Los estilos visuales vienen de theme/.
class PantallaAgregarProducto extends StatefulWidget {
  const PantallaAgregarProducto({super.key,required this.controlador,required this.rol});
  final ControladorAgregarProducto controlador;
  final RolUsuario rol;
  /// Responsabilidad única: Interfaz: Crea el estado asociado al widget y mantiene separada la configuración de su estado mutable.
  @override State<PantallaAgregarProducto> createState()=>_PantallaAgregarProductoState();
}
class _PantallaAgregarProductoState extends State<PantallaAgregarProducto>{
  final titulo=TextEditingController(), precio=TextEditingController(), descripcion=TextEditingController(), imagen=TextEditingController(), categoria=TextEditingController();
  /// Responsabilidad única: Libera controladores y recursos cuando el widget deja de utilizarse.
  @override
  void dispose() {
    for (final controlador in [titulo, precio, descripcion, imagen, categoria]) {
      controlador.dispose();
    }
    super.dispose();
  }
  /// Responsabilidad única: Interfaz: Construye la interfaz de este componente sin ejecutar directamente reglas de negocio ni llamadas HTTP.
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation: widget.controlador,builder:(context,_){
    if(!widget.rol.puedeGestionarProductos) return const Center(child: Text('Acceso restringido'));
    return ListView(padding: const EdgeInsets.all(20),children:[
      TextField(controller: titulo,decoration: const InputDecoration(labelText:'Título')),
      const SizedBox(height:12), TextField(controller: precio,keyboardType: TextInputType.number,decoration: const InputDecoration(labelText:'Precio')),
      const SizedBox(height:12), TextField(controller: categoria,decoration: const InputDecoration(labelText:'Categoría')),
      const SizedBox(height:12), TextField(controller: imagen,decoration: const InputDecoration(labelText:'URL de imagen')),
      const SizedBox(height:12), TextField(controller: descripcion,maxLines:4,decoration: const InputDecoration(labelText:'Descripción')),
      if(widget.controlador.error!=null)...[const SizedBox(height:12),Text(widget.controlador.error!)],
      const SizedBox(height:20), FilledButton(onPressed: widget.controlador.cargando?null:_guardar,child:Text(widget.controlador.cargando?'Guardando...':'Crear producto')),
    ]);
  });
  /// Responsabilidad única: Guarda los datos recibidos en el almacenamiento correspondiente.
  Future<void> _guardar() async {
    final p=Producto(id:0,titulo:titulo.text.trim(),precio:double.tryParse(precio.text.trim())??0,imagen:imagen.text.trim(),categoria:categoria.text.trim(),descripcion:descripcion.text.trim());
    final creado=await widget.controlador.agregar(widget.rol,p); if(!mounted||creado==null)return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Producto creado. Nuevo ID: ${creado.id}')));
    for(final c in [titulo,precio,descripcion,imagen,categoria]) c.clear();
  }
}
