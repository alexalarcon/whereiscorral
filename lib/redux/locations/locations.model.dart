import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression/image_compression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_geocoder/model.dart';
import 'package:flutter_geocoder/services/base.dart';
import 'package:flutter_geocoder/services/distant_google.dart';
import 'package:flutter_geocoder/services/local.dart';
import 'package:searchfield/searchfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

List<LocationModel> locationsModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationsModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel(
      {this.nombre,
      required this.lng,
      required this.lat,
      this.uuid,
      this.locationName,
      this.imagenUrl});

  String? nombre;
  double lng;
  double lat;

  String? uuid;
  String? imagenUrl;
  String? locationName;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      nombre: json["name"] ?? "",
      lng: json["lng"] ?? 0.0,
      lat: json["lat"] ?? 0.0,
      uuid: json["uuid"] ?? "",
      locationName: json["locationName"] ?? "",
      imagenUrl: json["imagenUrl"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": nombre,
        "uuid": uuid,
      };
}
