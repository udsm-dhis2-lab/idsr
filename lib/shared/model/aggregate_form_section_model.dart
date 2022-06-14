// To parse this JSON data, do
//
//     final aggregateFormSection = aggregateFormSectionFromJson(jsonString);

import 'dart:convert';

List<AggregateFormSection> aggregateFormSectionFromJson(String str) =>
    List<AggregateFormSection>.from(
        json.decode(str).map((x) => AggregateFormSection.fromJson(x)));

String aggregateFormSectionToJson(List<AggregateFormSection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AggregateFormSection {
  AggregateFormSection({
    required this.id,
    required this.name,
    required this.dataElement,
    this.description,
    required this.fieldGroups,
  });

  String id;
  String name;
  String dataElement;
  dynamic description;
  List<FieldGroup> fieldGroups;

  factory AggregateFormSection.fromJson(Map<String, dynamic> json) =>
      AggregateFormSection(
        id: json["id"],
        name: json["name"],
        dataElement: json["dataElement"],
        description: json["description"],
        fieldGroups: List<FieldGroup>.from(
            json["fieldGroups"].map((x) => FieldGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dataElement": dataElement,
        "description": description,
        "fieldGroups": List<dynamic>.from(fieldGroups.map((x) => x.toJson())),
      };
}

class FieldGroup {
  FieldGroup({
    required this.category,
    required this.categoryOptionCombos,
  });

  String category;
  List<CategoryOptionCombo> categoryOptionCombos;

  factory FieldGroup.fromJson(Map<String, dynamic> json) => FieldGroup(
        category: json["category"],
        categoryOptionCombos: List<CategoryOptionCombo>.from(
            json["categoryOptionCombos"]
                .map((x) => CategoryOptionCombo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "categoryOptionCombos":
            List<dynamic>.from(categoryOptionCombos.map((x) => x.toJson())),
      };
}

class CategoryOptionCombo {
  CategoryOptionCombo({
    this.isFormHorizontal,
    required this.fields,
  });

  bool? isFormHorizontal;
  List<Field> fields;

  factory CategoryOptionCombo.fromJson(Map<String, dynamic> json) =>
      CategoryOptionCombo(
        isFormHorizontal: json["isFormHorizontal"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isFormHorizontal": isFormHorizontal,
        "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
      };
}

class Field {
  Field({
    required this.categoryOptionCombo,
    required this.displayName,
  });

  String categoryOptionCombo;
  String displayName;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        categoryOptionCombo: json["categoryOptionCombo"],
        displayName: json["displayName"],
      );

  Map<String, dynamic> toJson() => {
        "categoryOptionCombo": categoryOptionCombo,
        "displayName": displayName,
      };
}
