/// Contenedor de composición usado únicamente en la capa de integración.
///
/// Permite que los adaptadores compartan contratos sin obligar a main.dart a
/// construir manualmente controladores, repositorios o servicios.
final class ContenedorDependencias {
  final Map<Type, Object> _servicios = <Type, Object>{};

  void registrar<T extends Object>(T servicio) {
    if (_servicios.containsKey(T)) {
      throw StateError('Ya existe un servicio registrado para el tipo $T');
    }

    _servicios[T] = servicio;
  }

  bool contiene<T extends Object>() => _servicios.containsKey(T);

  T obtener<T extends Object>() {
    final servicio = _servicios[T];

    if (servicio == null) {
      throw StateError('No existe un servicio registrado para el tipo $T');
    }

    return servicio as T;
  }

  T? intentarObtener<T extends Object>() => _servicios[T] as T?;
}
