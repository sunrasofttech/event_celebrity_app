import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

class CityModel {
  bool? status;
  List<CityDatum>? data;

  CityModel({this.status, this.data});

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        status: json["status"] ?? json["success"],
        data: json["data"] == null
            ? []
            : List<CityDatum>.from(
                json["data"]!.map((x) => CityDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CityDatum {
  String? id;
  String? name;
  String? state;

  CityDatum({this.id, this.name, this.state});

  factory CityDatum.fromJson(Map<String, dynamic> json) => CityDatum(
        id: json["id"],
        name: json["name"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state": state,
      };
}
