class Character {
  final int id;
  final String name;
  final String status;
  final String gender;
  final String image;
  final String species;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.gender,
    required this.image,
    required this.species,
  });

  Character.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        status = json["status"],
        gender = json["gender"],
        image = json["image"],
        species = json["species"];
}
