class GameType {
  int? id;
  String? shortCode;
  String? name;
  dynamic rate;
  DateTime? createdAt;
  DateTime? updatedAt;

  GameType({
    this.id,
    this.shortCode,
    this.name,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  factory GameType.fromJson(Map<String, dynamic> json) => GameType(
        id: json["id"] ?? "",
        shortCode: json["shortCode"] ?? "",
        name: json["name"] ?? "",
        rate: json["rate"] ?? "",
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shortCode": shortCode,
        "name": name,
        "rate": rate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
