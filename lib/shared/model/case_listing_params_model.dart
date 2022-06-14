// To parse this JSON data, do
//
//     final caseListingParams = caseListingParamsFromJson(jsonString);

import 'dart:convert';

List<CaseListingParams> caseListingParamsFromJson(String str) =>
    List<CaseListingParams>.from(
        json.decode(str).map((x) => CaseListingParams.fromJson(x)));

String caseListingParamsToJson(List<CaseListingParams> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CaseListingParams {
  CaseListingParams({
    required this.id,
    required this.label,
  });

  String id;
  String label;

  factory CaseListingParams.fromJson(Map<String, dynamic> json) =>
      CaseListingParams(
        id: json["id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
      };
}
