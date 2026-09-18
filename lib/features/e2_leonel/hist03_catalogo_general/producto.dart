class Producto {
  /// Inicializa la clase recibiendo sus dependencias o datos sin mezclar esa tarea con la lógica de negocio.
  const Producto({
    required this.id,
    required this.titulo,
    required this.precio,
    required this.imagen,
    required this.categoria,
    required this.descripcion,
  });

  final int id;
  final String titulo;
  final double precio;
  final String imagen;
  final String categoria;
  final String descripcion;

  /// Construye el modelo a partir de los datos JSON recibidos.
  factory Producto.desdeJson(Map<String, dynamic> json) => Producto(
        id: (json['id'] as num?)?.toInt() ?? 0,
        titulo: json['title']?.toString() ?? '',
        precio: (json['price'] as num?)?.toDouble() ?? 0,
        imagen: json['image']?.toString() ?? '',
        categoria: json['category']?.toString() ?? '',
        descripcion: json['description']?.toString() ?? '',
      );

  /// Convierte el modelo al formato esperado por la API.
  Map<String, dynamic> aJsonApi() => {
        'title': titulo,
        'price': precio,
        'description': descripcion,
        'image': imagen,
        'category': categoria,
      };

  /// Crea una copia cambiando únicamente los campos especificados.
  Producto copiarCon({
    int? id, String? titulo, double? precio, String? imagen,
    String? categoria, String? descripcion,
  }) => Producto(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        precio: precio ?? this.precio,
        imagen: imagen ?? this.imagen,
        categoria: categoria ?? this.categoria,
        descripcion: descripcion ?? this.descripcion,
      );
}
