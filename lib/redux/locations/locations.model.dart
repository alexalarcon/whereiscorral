import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<LocationModel> locationsModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationsModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel({this.nombre, this.location, this.numRutas, this.uuid});

  String? nombre;
  GeoPoint? location;
  String? uuid;
  // Timestamp? actualizacion;
  int? numRutas;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        nombre: json["nombre"] ?? "",
        location: json["location"] ?? const GeoPoint(0, 0),
        uuid: json["uuid"] ?? "",
        numRutas: json["numRutas"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "location": location,
        "numRutas": numRutas,
        "uuid": uuid,
      };
}
