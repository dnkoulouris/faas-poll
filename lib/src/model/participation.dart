class Participation {
  String? id;
  String? name;
  DateTime? createdAt;
  String? removedBy;

  Participation();

  Participation.fromMap(this.id, map) {
    if (map is Map) {
      if (map["name"] is String) name = map["name"];
      if (map["removedBy"] is String) removedBy = map["removedBy"];
      createdAt = DateTime.tryParse(map["createdAt"]);
    }
  }

  toMap() => {"name": name, "removedBy": removedBy, "createdAt": createdAt?.toIso8601String()};
}
