import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<LocationModel> locationsModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationsModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel(
      {this.idRuta, this.nombre, this.numRutas, this.uuid, this.actualizacion});

  String? idRuta;
  String? nombre;
  String? uuid;
  Timestamp? actualizacion;
  int? numRutas;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        idRuta: json["idRuta"] ?? "",
        nombre: json["nombre"] ?? "",
        uuid: json["uuid"] ?? "",
        actualizacion: json["actualizacion"] ?? "",
        numRutas: json["numRutas"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "idRuta": idRuta,
        "nombre": nombre,
        "numRutas": numRutas,
        "uuid": uuid,
        "actualizacion": actualizacion,
      };
}
