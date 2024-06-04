class Package {
  final String id;
  final String name;
  final String description;
  final String location;
  final String image;

  const Package(
      {required this.id,
      required this.name,
      required this.description,
      required this.location,
      required this.image});

  Package.fromJson(Map<String, dynamic> json)
      : id = json["idProducto"],
        name = json["nombre"],
        description = json["descripcion"],
        location = json["ubicacin"],
        image = json["imagen"];
}
