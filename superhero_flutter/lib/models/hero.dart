class SuperHero {
  final String name;
  final String fullName;
  final String path;

  const SuperHero(
      {required this.name, required this.fullName, required this.path});

  SuperHero.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        fullName = json["biography"]["full-name"],
        path = json["image"]["url"];
}
