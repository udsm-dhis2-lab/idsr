// To parse this JSON data, do
//
//     final trackedEntityAttribute = trackedEntityAttributeFromJson(jsonString);

import 'dart:convert';

List<TrackedEntityAttribute> trackedEntityAttributeFromJson(String str) =>
    List<TrackedEntityAttribute>.from(
        json.decode(str).map((x) => TrackedEntityAttribute.fromJson(x)));

String trackedEntityAttributeToJson(List<TrackedEntityAttribute> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrackedEntityAttribute {
  TrackedEntityAttribute({
    this.renderOptionsAsRadio,
    this.sortOrder,
    this.mandatory,
    this.trackedEntityAttribute,
  });

  bool? renderOptionsAsRadio;
  int? sortOrder;
  bool? mandatory;
  TrackedEntityAttributeClass? trackedEntityAttribute;

  factory TrackedEntityAttribute.fromJson(Map<String, dynamic> json) =>
      TrackedEntityAttribute(
        renderOptionsAsRadio: json["renderOptionsAsRadio"],
        sortOrder: json["sortOrder"],
        mandatory: json["mandatory"],
        trackedEntityAttribute: TrackedEntityAttributeClass.fromJson(
            json["trackedEntityAttribute"]),
      );

  Map<String, dynamic> toJson() => {
        "renderOptionsAsRadio": renderOptionsAsRadio,
        "sortOrder": sortOrder,
        "mandatory": mandatory,
        "trackedEntityAttribute": trackedEntityAttribute?.toJson(),
      };

  @override
  String toString() {
    return '{renderOptionsAsRadio: $renderOptionsAsRadio, sortOrder: $sortOrder, mandatory: $mandatory, trackedEntityAttribute: $trackedEntityAttribute}';
  }
}

class TrackedEntityAttributeClass {
  TrackedEntityAttributeClass({
    this.id,
    this.generated,
    this.displayName,
    this.unique,
    this.valueType,
    this.attributeValues,
    this.formName,
    this.optionSet,
  });

  String? id;
  bool? generated;
  String? displayName;
  bool? unique;
  String? valueType;
  List<AttributeValue>? attributeValues;
  String? formName;
  OptionSet? optionSet;

  factory TrackedEntityAttributeClass.fromJson(Map<String, dynamic> json) =>
      TrackedEntityAttributeClass(
        id: json["id"],
        generated: json["generated"],
        displayName: json["displayName"],
        unique: json["unique"],
        valueType: json["valueType"],
        attributeValues: List<AttributeValue>.from(
            json["attributeValues"].map((x) => AttributeValue.fromJson(x))),
        formName: json["formName"] == null ? null : json["formName"],
        optionSet: json["optionSet"] == null
            ? null
            : OptionSet.fromJson(json["optionSet"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "generated": generated,
        "displayName": displayName,
        "unique": unique,
        "valueType": valueType,
        "attributeValues":
            List<dynamic>.from((attributeValues ?? []).map((x) => x.toJson())),
        "formName": formName == null ? null : formName,
        "optionSet": optionSet == null ? null : optionSet?.toJson(),
      };
}

class AttributeValue {
  AttributeValue({
    this.value,
    this.attribute,
  });

  String? value;
  Attribute? attribute;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
        value: json["value"],
        attribute: Attribute.fromJson(json["attribute"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "attribute": attribute?.toJson(),
      };
}

class Attribute {
  Attribute({
    this.id,
  });

  String? id;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class OptionSet {
  OptionSet({
    this.name,
    this.id,
    this.options,
  });

  String? name;
  String? id;
  List<Option>? options;

  factory OptionSet.fromJson(Map<String, dynamic> json) => OptionSet(
        name: json["name"],
        id: json["id"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "options": List<dynamic>.from((options ?? []).map((x) => x.toJson())),
      };
}

class Option {
  Option({
    this.code,
    this.id,
    this.name,
  });

  String? code;
  String? id;
  String? name;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        code: json["code"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "id": id,
        "name": name,
      };
}
