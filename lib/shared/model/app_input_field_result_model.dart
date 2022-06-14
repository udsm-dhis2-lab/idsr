// To parse this JSON data, do
//
//     final fieldInputResult = fieldInputResultFromJson(jsonString);

import 'dart:convert';

FieldInputResult fieldInputResultFromJson(String str) =>
    FieldInputResult.fromJson(json.decode(str));

String fieldInputResultToJson(FieldInputResult data) =>
    json.encode(data.toJson());

class FieldInputResult {
  FieldInputResult({
    this.attributeOptionCombo,
    this.categoryOptionCombo,
    required this.value,
    required this.fieldid,
  });

  String? attributeOptionCombo;
  String? categoryOptionCombo;
  String value;
  String fieldid;

  factory FieldInputResult.fromJson(Map<String, dynamic> json) =>
      FieldInputResult(
        attributeOptionCombo: json["attributeOptionCombo"],
        categoryOptionCombo: json["categoryOptionCombo"],
        value: json["value"],
        fieldid: json["fieldid"],
      );

  Map<String, dynamic> toJson() => {
        "attributeOptionCombo": attributeOptionCombo,
        "categoryOptionCombo": categoryOptionCombo,
        "value": value,
        "fieldid": fieldid,
      };
}
