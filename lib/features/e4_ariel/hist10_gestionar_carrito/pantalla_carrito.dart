/// Épica 4 - Compras / carrito.
/// Código reorganizado desde US09-US10 del repositorio del equipo.

import 'package:flutter/material.dart';
import '../../e1_sebastian/hist01_login_perfiles/asignacion_perfiles/rol_usuario.dart';
import '../hist09_agregar_carrito/estado_carrito/estado_carrito.dart';
import 'controlador_gestion_carrito.dart';

class PantallaCarrito extends StatelessWidget {
  const PantallaCarrito({super.key,required this.controlador,required this.estado,required this.rol,required this.usuario});
  final ControladorGestionCarrito controlador;
  final EstadoCarrito estado;
  final RolUsuario rol;
  final int usuario;
  /// Responsabilidad única: Interfaz: Construye la interfaz de este componente sin ejecutar directamente reglas de negocio ni llamadas HTTP.
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:Listenable.merge([controlador,estado]),builder:(context,_){
    if(!rol.puedeUsarCarrito)return const Center(child:Text('Esta sección no está disponible.'));
    if(estado.vacio)return const Center(child:Text('Tu carrito está vacío, explora el catálogo'));
    return Column(children:[
      if(controlador.sincronizando)const LinearProgressIndicator(),
      Expanded(child:ListView.builder(itemCount:estado.lineas.length,itemBuilder:(context,i){final l=estado.lineas[i];return ListTile(
        title:Text(l.producto.titulo),subtitle:Text('Subtotal: \$${l.subtotal.toStringAsFixed(2)}'),
        leading:IconButton(onPressed:controlador.sincronizando?null:()=>controlador.cambiarCantidad(rol:rol,usuario:usuario,productoId:l.producto.id,cantidad:l.cantidad-1),icon:const Icon(Icons.remove)),
        trailing:Wrap(crossAxisAlignment:WrapCrossAlignment.center,children:[Text('${l.cantidad}'),IconButton(onPressed:controlador.sincronizando?null:()=>controlador.cambiarCantidad(rol:rol,usuario:usuario,productoId:l.producto.id,cantidad:l.cantidad+1),icon:const Icon(Icons.add)),IconButton(onPressed:controlador.sincronizando?null:()=>controlador.quitar(rol:rol,usuario:usuario,productoId:l.producto.id),icon:const Icon(Icons.delete_outline))]),
      );})),
      Padding(padding:const EdgeInsets.all(16),child:Text('Total: \$${estado.total.toStringAsFixed(2)}',style:Theme.of(context).textTheme.titleLarge)),
    ]);
  });
}
