/// Épica 2 - Catálogo.
/// Código reorganizado desde US03-US05 del repositorio del equipo.

import 'package:flutter/material.dart';
import 'controlador_filtro_categorias.dart';

class SelectorCategorias extends StatelessWidget {
  const SelectorCategorias({super.key, required this.controlador, required this.alSeleccionarTodos});
  final ControladorFiltroCategorias controlador;
  final Future<void> Function() alSeleccionarTodos;

  /// Responsabilidad única: Interfaz: Construye la interfaz de este componente sin ejecutar directamente reglas de negocio ni llamadas HTTP.
  @override Widget build(BuildContext context) => SizedBox(
    height: 62,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      scrollDirection: Axis.horizontal,
      itemCount: controlador.categorias.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final categoria = controlador.categorias[i];
        return ChoiceChip(
          label: Text(categoria),
          selected: categoria == controlador.categoriaSeleccionada,
          onSelected: (seleccionado) async {
            if (!seleccionado) return;
            await controlador.seleccionar(categoria);
            if (categoria == ControladorFiltroCategorias.todos) await alSeleccionarTodos();
          },
        );
      },
    ),
  );
}
