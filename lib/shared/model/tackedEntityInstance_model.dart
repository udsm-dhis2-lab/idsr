// To parse this JSON data, do
//
//     final trackedEntityInstance = trackedEntityInstanceFromJson(jsonString);

import 'dart:convert';

List<TrackedEntityInstance> trackedEntityInstanceFromJson(String str) =>
    List<TrackedEntityInstance>.from(
        json.decode(str).map((x) => TrackedEntityInstance.fromJson(x)));

String trackedEntityInstanceToJson(List<TrackedEntityInstance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrackedEntityInstance {
  TrackedEntityInstance({
    this.orgUnit,
    this.trackedEntityInstance,
    this.attributes,
    this.enrollments,
  });

  String? orgUnit;
  String? trackedEntityInstance;
  List<Attribute>? attributes;
  List<Enrollment>? enrollments;

  factory TrackedEntityInstance.fromJson(Map<String, dynamic> json) =>
      TrackedEntityInstance(
        orgUnit: json["orgUnit"],
        trackedEntityInstance: json["trackedEntityInstance"],
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
        enrollments: List<Enrollment>.from(
            json["enrollments"].map((x) => Enrollment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orgUnit": orgUnit,
        "trackedEntityInstance": trackedEntityInstance,
        "attributes":
            List<dynamic>.from((attributes ?? []).map((x) => x.toJson())),
        "enrollments":
            List<dynamic>.from((enrollments ?? []).map((x) => x.toJson())),
      };
}

class Attribute {
  Attribute({
    this.code,
    this.attribute,
    this.value,
  });

  String? code;
  String? attribute;
  String? value;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        code: json["code"] == null ? null : json["code"],
        attribute: json["attribute"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "attribute": attribute,
        "value": value,
      };
}

class Enrollment {
  Enrollment({
    this.storedBy,
    this.createdAtClient,
    this.program,
    this.lastUpdated,
    this.created,
    this.orgUnit,
    this.trackedEntityInstance,
    this.enrollment,
    this.trackedEntityType,
    this.lastUpdatedAtClient,
    this.orgUnitName,
    this.enrollmentDate,
    this.deleted,
    this.incidentDate,
    this.status,
    this.notes,
    this.relationships,
    this.events,
    this.attributes,
  });

  String? storedBy;
  DateTime? createdAtClient;
  String? program;
  DateTime? lastUpdated;
  DateTime? created;
  String? orgUnit;
  String? trackedEntityInstance;
  String? enrollment;
  String? trackedEntityType;
  DateTime? lastUpdatedAtClient;
  String? orgUnitName;
  DateTime? enrollmentDate;
  bool? deleted;
  DateTime? incidentDate;
  String? status;
  List<dynamic>? notes;
  List<dynamic>? relationships;
  List<Event>? events;
  List<dynamic>? attributes;

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
        storedBy: json["storedBy"],
        createdAtClient: DateTime.parse(json["createdAtClient"]),
        program: json["program"],
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        created: DateTime.parse(json["created"]),
        orgUnit: json["orgUnit"],
        trackedEntityInstance: json["trackedEntityInstance"],
        enrollment: json["enrollment"],
        trackedEntityType: json["trackedEntityType"],
        lastUpdatedAtClient: DateTime.parse(json["lastUpdatedAtClient"]),
        orgUnitName: json["orgUnitName"],
        enrollmentDate: DateTime.parse(json["enrollmentDate"]),
        deleted: json["deleted"],
        incidentDate: DateTime.parse(json["incidentDate"]),
        status: json["status"],
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        relationships: List<dynamic>.from(json["relationships"].map((x) => x)),
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
        attributes: List<dynamic>.from(json["attributes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "storedBy": storedBy,
        "createdAtClient": createdAtClient?.toIso8601String(),
        "program": program,
        "lastUpdated": lastUpdated?.toIso8601String(),
        "created": created?.toIso8601String(),
        "orgUnit": orgUnit,
        "trackedEntityInstance": trackedEntityInstance,
        "enrollment": enrollment,
        "trackedEntityType": trackedEntityType,
        "lastUpdatedAtClient": lastUpdatedAtClient?.toIso8601String(),
        "orgUnitName": orgUnitName,
        "enrollmentDate": enrollmentDate?.toIso8601String(),
        "deleted": deleted,
        "incidentDate": incidentDate?.toIso8601String(),
        "status": status,
        "notes": List<dynamic>.from((notes ?? []).map((x) => x)),
        "relationships":
            List<dynamic>.from((relationships ?? []).map((x) => x)),
        "events": List<dynamic>.from((events ?? []).map((x) => x.toJson())),
        "attributes": List<dynamic>.from((attributes ?? []).map((x) => x)),
      };
}

class Event {
  Event({
    this.storedBy,
    this.dueDate,
    this.program,
    this.event,
    this.programStage,
    this.orgUnit,
    this.trackedEntityInstance,
    this.enrollment,
    this.enrollmentStatus,
    this.status,
    this.orgUnitName,
    this.eventDate,
    this.attributeCategoryOptions,
    this.lastUpdated,
    this.created,
    this.deleted,
    this.attributeOptionCombo,
    this.dataValues,
    this.notes,
    this.relationships,
  });

  String? storedBy;
  DateTime? dueDate;
  String? program;
  String? event;
  String? programStage;
  String? orgUnit;
  String? trackedEntityInstance;
  String? enrollment;
  String? enrollmentStatus;
  String? status;
  String? orgUnitName;
  DateTime? eventDate;
  String? attributeCategoryOptions;
  DateTime? lastUpdated;
  DateTime? created;
  bool? deleted;
  String? attributeOptionCombo;
  List<DataValue>? dataValues;
  List<dynamic>? notes;
  List<dynamic>? relationships;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        storedBy: json["storedBy"],
        dueDate: DateTime.parse(json["dueDate"]),
        program: json["program"],
        event: json["event"],
        programStage: json["programStage"],
        orgUnit: json["orgUnit"],
        trackedEntityInstance: json["trackedEntityInstance"],
        enrollment: json["enrollment"],
        enrollmentStatus: json["enrollmentStatus"],
        status: json["status"],
        orgUnitName: json["orgUnitName"],
        eventDate: DateTime.parse(json["eventDate"]),
        attributeCategoryOptions: json["attributeCategoryOptions"],
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        created: DateTime.parse(json["created"]),
        deleted: json["deleted"],
        attributeOptionCombo: json["attributeOptionCombo"],
        dataValues: List<DataValue>.from(
            json["dataValues"].map((x) => DataValue.fromJson(x))),
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        relationships: List<dynamic>.from(json["relationships"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "storedBy": storedBy,
        "dueDate": dueDate?.toIso8601String(),
        "program": program,
        "event": event,
        "programStage": programStage,
        "orgUnit": orgUnit,
        "trackedEntityInstance": trackedEntityInstance,
        "enrollment": enrollment,
        "enrollmentStatus": enrollmentStatus,
        "status": status,
        "orgUnitName": orgUnitName,
        "eventDate": eventDate?.toIso8601String(),
        "attributeCategoryOptions": attributeCategoryOptions,
        "lastUpdated": lastUpdated?.toIso8601String(),
        "created": created?.toIso8601String(),
        "deleted": deleted,
        "attributeOptionCombo": attributeOptionCombo,
        "dataValues":
            List<dynamic>.from((dataValues ?? []).map((x) => x.toJson())),
        "notes": List<dynamic>.from((notes ?? []).map((x) => x)),
        "relationships":
            List<dynamic>.from((relationships ?? []).map((x) => x)),
      };
}

class DataValue {
  DataValue({
    this.lastUpdated,
    this.created,
    this.dataElement,
    this.value,
    this.providedElsewhere,
  });

  DateTime? lastUpdated;
  DateTime? created;
  String? dataElement;
  String? value;
  bool? providedElsewhere;

  factory DataValue.fromJson(Map<String, dynamic> json) => DataValue(
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        created: DateTime.parse(json["created"]),
        dataElement: json["dataElement"],
        value: json["value"],
        providedElsewhere: json["providedElsewhere"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdated": lastUpdated?.toIso8601String(),
        "created": created?.toIso8601String(),
        "dataElement": dataElement,
        "value": value ?? '',
        "providedElsewhere": providedElsewhere,
      };
}
