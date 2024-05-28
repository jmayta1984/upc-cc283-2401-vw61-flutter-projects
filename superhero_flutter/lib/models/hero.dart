class SuperHero {
  final String id;
  final String name;
  final String fullName;
  final String path;

  const SuperHero(
      {required this.id,
      required this.name,
      required this.fullName,
      required this.path});

  SuperHero.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        fullName = json["biography"]["full-name"],
        path = json["image"]["url"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "full_name": fullName,
    };
  }
}
