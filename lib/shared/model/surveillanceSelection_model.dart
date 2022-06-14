// To parse this JSON data, do
//
//     final surveillanceSelection = surveillanceSelectionFromJson(jsonString);

import 'dart:convert';

List<SurveillanceSelection> surveillanceSelectionFromJson(String str) =>
    List<SurveillanceSelection>.from(
        json.decode(str).map((x) => SurveillanceSelection.fromJson(x)));

String surveillanceSelectionToJson(List<SurveillanceSelection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SurveillanceSelection {
  SurveillanceSelection({
    required this.header,
    required this.description,
    required this.icon,
    required this.routePath,
  });

  String header;
  String description;
  String icon;
  String routePath;

  factory SurveillanceSelection.fromJson(Map<String, dynamic> json) =>
      SurveillanceSelection(
        header: json["header"],
        description: json["description"],
        icon: json["icon"],
        routePath: json["routePath"],
      );

  Map<String, dynamic> toJson() => {
        "header": header,
        "description": description,
        "icon": icon,
        "routePath": routePath,
      };
}
