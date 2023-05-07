import 'dart:convert';

List<BarNavigationModel> barNavigationModelFromJson(String str) =>
    List<BarNavigationModel>.from(
        json.decode(str).map((x) => BarNavigationModel.fromJson(x)));

String barNavigationModelToJson(List<BarNavigationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarNavigationModel {
  BarNavigationModel({
    this.currentIndex,
    this.idBarNavigationio,
  });

  int? currentIndex;
  String? idBarNavigationio;

  factory BarNavigationModel.fromJson(Map<String, dynamic> json) =>
      BarNavigationModel(
        currentIndex: json["currentIndex"] ?? 0,
        idBarNavigationio: json["idBarNavigationio"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "currentIndex": currentIndex,
        "idBarNavigationio": idBarNavigationio,
      };
}
