// To parse this JSON data, do
//
//     final trackerFormSection = trackerFormSectionFromJson(jsonString);

import 'dart:convert';

List<TrackerFormSection> trackerFormSectionFromJson(String str) =>
    List<TrackerFormSection>.from(
        json.decode(str).map((x) => TrackerFormSection.fromJson(x)));

String trackerFormSectionToJson(List<TrackerFormSection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrackerFormSection {
  TrackerFormSection({
    this.id,
    this.name,
    this.description,
    this.fieldGroups,
  });

  String? id;
  String? name;
  String? description;
  List<FieldGroup>? fieldGroups;

  factory TrackerFormSection.fromJson(Map<String, dynamic> json) =>
      TrackerFormSection(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        fieldGroups: List<FieldGroup>.from(
            json["fieldGroups"].map((x) => FieldGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "fieldGroups":
            List<dynamic>.from((fieldGroups ?? []).map((x) => x.toJson())),
      };
}

class FieldGroup {
  FieldGroup({
    this.isFormHorizontal,
    this.fields,
  });

  bool? isFormHorizontal;
  List<Field>? fields;

  factory FieldGroup.fromJson(Map<String, dynamic> json) => FieldGroup(
        isFormHorizontal:
            json["isFormHorizontal"] == null ? null : json["isFormHorizontal"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isFormHorizontal": isFormHorizontal == null ? null : isFormHorizontal,
        "fields": List<dynamic>.from((fields ?? []).map((x) => x.toJson())),
      };
}

class Field {
  Field({
    this.id,
  });

  String? id;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
