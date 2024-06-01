class SuperHero {
  final String id;
  final String name;
  final String fullName;
  final String path;
  final Powerstats stats;

  const SuperHero(
      {required this.id,
      required this.name,
      required this.fullName,
      required this.path,
      required this.stats});

  SuperHero.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        fullName = json["biography"]["full-name"],
        path = json["image"]["url"],
        stats = Powerstats.fromJson(json["powerstats"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "full_name": fullName,
    };
  }
}

class FavoriteHero {
  final String id;
  final String name;
  final String fullName;

  FavoriteHero.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        fullName = map["full_name"];
}

class Powerstats {
  final double intelligence;
  final double strength;
  final double speed;
  final double power;
  final double durability;
  final double combat;

  Powerstats(
      {required this.intelligence,
      required this.strength,
      required this.speed,
      required this.power,
      required this.durability,
      required this.combat});

  Powerstats.fromJson(Map<String, dynamic> json)
      : intelligence = double.parse(
            (json["intelligence"] != "null" ? json["intelligence"] : "0")),
        strength =
            double.parse((json["strength"] != "null" ? json["strength"] : "0")),
        speed = double.parse((json["speed"] != "null" ? json["speed"] : "0")),
        power = double.parse((json["power"] != "null" ? json["power"] : "0")),
        durability = double.parse(
            (json["durability"] != "null" ? json["durability"] : "0")),
        combat =
            double.parse((json["combat"] != "null" ? json["combat"] : "0"));
}
