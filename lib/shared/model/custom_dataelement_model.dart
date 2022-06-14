// To parse this JSON data, do
//
//     final customDataElement = customDataElementFromJson(jsonString);

import 'dart:convert';

List<CustomDataElement> customDataElementFromJson(String str) =>
    List<CustomDataElement>.from(
        json.decode(str).map((x) => CustomDataElement.fromJson(x)));

String customDataElementToJson(List<CustomDataElement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomDataElement {
  CustomDataElement({
    required this.name,
    this.displayFormName,
    required this.id,
    required this.shortName,
    required this.valueType,
    this.mandatory,
  });

  String name;
  String? displayFormName;
  String id;
  String shortName;
  String valueType;
  bool? mandatory;

  factory CustomDataElement.fromJson(Map<String, dynamic> json) =>
      CustomDataElement(
        name: json["name"],
        displayFormName: json["displayFormName"],
        id: json["id"],
        shortName: json["shortName"],
        valueType: json["valueType"],
        mandatory: json["mandatory"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "displayFormName": displayFormName,
        "id": id,
        "shortName": shortName,
        "valueType": valueType,
        "mandatory": mandatory,
      };
}
