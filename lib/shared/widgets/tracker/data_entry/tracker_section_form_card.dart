import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/engine/program_rule/models/tracker_rule_result.model.dart';
import 'package:dhis2_flutter_sdk/modules/engine/program_rule/tracker_rule_engine.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';

// import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked_entity_attribute_value.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/attribute_option.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_rule_action.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';
import 'package:eIDSR/shared/helpers/app_helper.dart';
import 'package:eIDSR/shared/model/app_input_field_result_model.dart';
import 'package:eIDSR/shared/model/option.model.dart';

// import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';
import 'package:eIDSR/shared/model/trackedEntityAttribute_model.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/model/trackerFromSection_model.dart';
import 'package:eIDSR/shared/widgets/form/app_field_input.dart';
// import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';

class TrackerFormCardSection extends StatefulWidget {
  final formSection;
  TrackedEntityInstance? trackedEntityInstance;
  OrganisationUnit? selectedOrgUnit;
  String programId;
  List<ProgramRuleAction> programRuleActions;
  final Function(TrackerRuleResult) onTrackerRulesChanged;

  TrackerFormCardSection(
      {Key? key,
      required this.formSection,
      this.trackedEntityInstance,
      this.selectedOrgUnit,
      required this.programId,
      required this.programRuleActions,
      required this.onTrackerRulesChanged})
      : super(key: key);

  @override
  _TrackerFormCardSectionState createState() => _TrackerFormCardSectionState();
}

class _TrackerFormCardSectionState extends State<TrackerFormCardSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: AppColors.blueThemeColor, width: 5))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    Text(
                      widget.formSection['name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.blueThemeColor),
                    )
                  ],
                ),
              ),
              // Divider()
              Container(
                child: Column(
                  children: [
                    ...loadFormGroups(),
                  ],
                ),
              )
            ],
          ),
        ),
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      ),
    );
  }

  loadFormGroups() {
    final formGroups = (widget.formSection['fieldGroups'] ?? [])
        .map<Widget>((fieldGroup) => fieldGroup['isFormHorizontal'] == true
            ? Row(
                children: [
                  ...?(fieldGroup['fields'] ?? [])
                      .map<Widget>((field) => Flexible(
                          child: showField(field!.attribute) == false
                              ? SizedBox(
                                  height: 0,
                                  width: 0,
                                )
                              : widget.trackedEntityInstance?.attributes == null
                                  ? AppFieldInput(
                                      // field: field,
                                      valueType: field!.valueType,
                                      displayName: field!.name,
                                      mandatory: field!.mandatory,
                                      options: transformFieldOptions(field),
                                      fieldId: field!.attribute,
                                      onFieldInputChanged: (fieldResult) {
                                        onFieldInputChange(field!, fieldResult);
                                      },
                                    )
                                  : AppFieldInput(
                                      // field: field,
                                      valueType: field!.valueType,
                                      displayName: field!.name,
                                      mandatory: field!.mandatory,
                                      options: transformFieldOptions(field),
                                      fieldId: field!.attribute,
                                      inputValue: getAttributeValue(
                                          widget.trackedEntityInstance
                                              ?.attributes,
                                          field.attribute),
                                      onFieldInputChanged: (fieldResult) {
                                        onFieldInputChange(field!, fieldResult);
                                      })))
                      .toList()
                ],
              )
            : Column(
                children: [
                  ...?(fieldGroup['fields'] ?? [])
                      .map<Widget>((field) => showField(field!.attribute) ==
                              false
                          ? SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : Row(
                              children: [
                                Flexible(
                                    child: widget.trackedEntityInstance
                                                ?.attributes ==
                                            null
                                        ? AppFieldInput(
                                            // field: field,
                                            valueType: field!.valueType,
                                            displayName: field!.name,
                                            mandatory: field!.mandatory,
                                            options:
                                                transformFieldOptions(field),
                                            fieldId: field!.attribute,
                                            onFieldInputChanged: (fieldResult) {
                                              onFieldInputChange(
                                                  field!, fieldResult);
                                            })
                                        : AppFieldInput(
                                            // field: field,
                                            valueType: field!.valueType,
                                            displayName: field!.name,
                                            mandatory: field!.mandatory,
                                            options:
                                                transformFieldOptions(field),
                                            fieldId: field!.attribute,
                                            inputValue: getAttributeValue(
                                                widget.trackedEntityInstance
                                                    ?.attributes,
                                                field.attribute),
                                            onFieldInputChanged: (fieldResult) {
                                              onFieldInputChange(
                                                  field!, fieldResult);
                                            }))
                              ],
                            ))
                      .toList()
                ],
              ))
        .toList();
    return formGroups;
  }

  showField(String id) {
    List<ProgramRuleAction> actionsMatchingAttribute =
        widget.programRuleActions.where((ProgramRuleAction action) {
      return action.trackedEntityAttribute == id;
    }).toList();

    if (actionsMatchingAttribute.length == 0) {
      return true;
    } else {
      return actionsMatchingAttribute[0].programRuleActionType.toString() ==
              "HIDEFIELD"
          ? false
          : true;
    }
  }

  getAttributeValue(attribute, String attributeId) {
    List<TrackedEntityAttributeValue> caseIdAttribute = attribute
        .where((attributeItem) => attributeItem.attribute == attributeId)
        .toList();
    return caseIdAttribute.length > 0 ? caseIdAttribute[0].value : '';
  }

  transformFieldOptions(field) {
    return field.options == null
        ? []
        : (field.options as List<AttributeOption>).map((optionItem) {
            return new DataOption(
                name: optionItem.name as String,
                code: optionItem.code as String);
          }).toList();
  }

// TrackedEntityInstance trackedEntityInstance,
  onFieldInputChange(
      ProgramTrackedEntityAttribute field, FieldInputResult fieldResult) async {
    // print(widget.trackedEntityInstance?.synced);
    // print(widget.trackedEntityInstance?.dirty);
    if (widget.trackedEntityInstance?.synced == true) {
      // print("here change vitu");

      widget.trackedEntityInstance?.synced = false;
      widget.trackedEntityInstance?.dirty = true;

      await D2Touch.trackerModule.trackedEntityInstance
          .setData(widget.trackedEntityInstance)
          .save();
    }

    if (field.valueType == "BOOLEAN") {
      fieldResult.value = fieldResult.value == "Yes" ? "true" : "false";
    }

    TrackedEntityAttributeValue? existingTrackedEntityAttributeValue = await D2Touch
        .trackerModule.trackedEntityAttributeValue
        .byId(
            '${widget.trackedEntityInstance?.trackedEntityInstance}_${field.attribute}')
        .getOne();

    if (existingTrackedEntityAttributeValue != null) {
      existingTrackedEntityAttributeValue.value = fieldResult.value;
      existingTrackedEntityAttributeValue.dirty = true;
      existingTrackedEntityAttributeValue.synced = false;
      existingTrackedEntityAttributeValue.lastUpdated =
          DateTime.now().toIso8601String();
    }

    final TrackedEntityAttributeValue trackedEntityAttributeValue =
        existingTrackedEntityAttributeValue == null
            ? TrackedEntityAttributeValue(
                id:
                    '${widget.trackedEntityInstance?.trackedEntityInstance}_${field.attribute}',
                name:
                    '${widget.trackedEntityInstance?.trackedEntityInstance}_${field.attribute}',
                dirty: true,
                attribute: field.attribute,
                trackedEntityInstance:
                    widget.trackedEntityInstance?.trackedEntityInstance,
                value: fieldResult.value,
                lastUpdated: DateTime.now().toIso8601String())
            : existingTrackedEntityAttributeValue;

    var x = await D2Touch.trackerModule.trackedEntityAttributeValue
        .setData(trackedEntityAttributeValue)
        .save();

    var y = await D2Touch.trackerModule.trackedEntityAttributeValue
        .byId(trackedEntityAttributeValue.id as String)
        .getOne();

    // print("[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]");
    // print(widget.trackedEntityInstance?.trackedEntityInstance);
    // print(x);
    // print(trackedEntityAttributeValue.toJson());
    // print(y.toJson());

    TrackerRuleResult trackerRuleResult = await TrackerRuleEngine.execute(
        trackedEntityInstance:
            widget.trackedEntityInstance as TrackedEntityInstance,
        program: widget.programId);

    // // print("****** te tei ***********************");
    // trackerRuleResult.trackedEntityInstance.attributes
    //     ?.forEach((TrackedEntityAttributeValue element) {
    //   if (element.attribute == "oqpyDVwngtS") {
    //     // print(element.toJson());
    //   }
    // });

    // TODO: remove the hardcoded map that used to test hiding fields
    // trackerRuleResult.programRuleActions = trackerRuleResult.programRuleActions.map((ProgramRuleAction action) {
    //
    //   action.programRuleActionType = "HIDE";
    //
    //   return action;
    // }).toList();

    widget.onTrackerRulesChanged(trackerRuleResult);

    // // print(x.programRuleActions[0].toJson());
    // newCaseTrackedEntityInstance.set
  }
}
