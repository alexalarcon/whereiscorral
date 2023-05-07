// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  AuthModel({
    this.admin,
    this.createdAt,
    this.createdBy,
    this.deleted,
    this.email,
    this.generation,
    this.id,
    this.modifyAt,
    this.name,
    this.photo,
    this.curriculum,
  });

  bool? admin;
  DateTime? createdAt;
  String? createdBy;
  bool? deleted;
  String? email;
  String? curriculum;
  String? generation;
  String? id;
  DateTime? modifyAt;
  String? name;
  String? photo;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        admin: json["admin"],
        createdAt: (json["createdAt"] == null)
            ? null
            : DateTime.parse(json["createdAt"]),
        createdBy: (json["createdBy"] == null) ? null : json["createdBy"],
        deleted: (json["deleted"] == null) ? null : json["deleted"],
        email: (json["email"] == null) ? null : json["email"],
        curriculum: (json["curriculum"] == null) ? null : json["curriculum"],
        generation: (json["generation"] == null) ? null : json["generation"],
        id: (json["id"] == null) ? null : json["id"],
        modifyAt: (json["modifyAt"] == null)
            ? null
            : DateTime.parse(json["modifyAt"]),
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "admin": admin,
        "createdAt": createdAt?.toIso8601String(),
        "createdBy": createdBy,
        "deleted": deleted,
        "email": email,
        "generation": generation,
        "curriculum": curriculum,
        "id": id,
        "modifyAt": modifyAt?.toIso8601String(),
        "name": name,
        "photo": photo,
      };
}
