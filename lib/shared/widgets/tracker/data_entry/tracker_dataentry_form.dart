import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/enrollment.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked_entity_attribute_value.entity.dart';
import 'package:dhis2_flutter_sdk/modules/engine/program_rule/models/tracker_rule_result.model.dart';
import 'package:dhis2_flutter_sdk/modules/engine/program_rule/tracker_rule_engine.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_rule_action.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';

// import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';
import 'package:eIDSR/shared/widgets/tracker/data_entry/tracker_section_form_card.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';
import 'package:eIDSR/shared/widgets/text_widgets/app_text_widget.dart';
// import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';

class TrackerDataEntryForm extends StatefulWidget {
  // final formValues;
  List<ProgramTrackedEntityAttribute> programAttributes;
  TrackedEntityInstance? trackedEntityInstance;
  OrganisationUnit? selectedOrgUnit;
  String programId;
  final trackerformSection;
  final bool disableCompleting;
  final attributeParams;

  TrackerDataEntryForm({
    Key? key,
    this.trackedEntityInstance,
    required this.programAttributes,
    required this.trackerformSection,
    this.selectedOrgUnit,
    this.attributeParams,
    required this.disableCompleting,
    required this.programId,
  }) : super(key: key);

  @override
  _TrackerDataEntryState createState() => _TrackerDataEntryState();
}

class _TrackerDataEntryState extends State<TrackerDataEntryForm> {
  double topSelectionHeight = 60;
  List trackerformSections = [];
  List<ProgramRuleAction> programRuleActions = [];

  AppBar trackerAppBar = AppBar(
    title: Text('Data Entry'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: trackerAppBar,
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            Container(
              width: double.maxFinite,
              color: AppColors.whiteSmoke,
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              // height: topSelectionHeight,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 4,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 8, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width *
                                            1) -
                                        20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                            future: dataEntryOUtoDisplay(widget
                                                .trackedEntityInstance
                                                ?.enrollments),
                                            builder: (context, snapshot) =>
                                                snapshot.hasData &&
                                                        snapshot.data != null
                                                    ? TextButton.icon(
                                                        icon: Icon(
                                                          Icons
                                                              .account_tree_outlined,
                                                          color: AppColors
                                                              .textMuted,
                                                        ),
                                                        label: Text(
                                                          (snapshot.data
                                                              as String),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: AppColors
                                                                  .textMuted),
                                                        ),
                                                        onPressed: null,
                                                      )
                                                    : TextButton.icon(
                                                        icon: Icon(
                                                          Icons
                                                              .account_tree_outlined,
                                                          color: AppColors
                                                              .textMuted,
                                                        ),
                                                        label: Text(
                                                          'Select Facility',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: AppColors
                                                                  .textMuted),
                                                        ),
                                                        onPressed: null,
                                                      )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder(
                                future: getTrackerFormSections(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          top: 15, left: 10, right: 10),

                                      child: Column(children: [
                                        ...(snapshot.data as List).map((data) {
                                          return TrackerFormCardSection(
                                            formSection: data,
                                            selectedOrgUnit:
                                                widget.selectedOrgUnit,
                                            programId: widget.programId,
                                            programRuleActions:
                                                programRuleActions,
                                            trackedEntityInstance:
                                                widget.trackedEntityInstance,
                                            onTrackerRulesChanged:
                                                (TrackerRuleResult
                                                    trackerRuleResult) {
                                              applyRules(trackerRuleResult);
                                            },
                                          );
                                        }),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              right: 5,
                                              left: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      showSavingOptions();
                                                    },
                                                    child: Text("SAVE")),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      // ),
                                    );
                                  } else {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              left: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 2))),
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          left: 30,
                                          right: 30),
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Column(
                                                children: [
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    backgroundColor:
                                                        Colors.black12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    // valueColor: Colors.blue,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Loading Form...',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .textPrimary),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future<bool> canComplete() async {
    // TODO add check for completion
    List<TrackedEntityAttributeValue> upToDateTEIAttributeValues = await D2Touch
        .trackerModule.trackedEntityAttributeValue
        .where(
            attribute: "trackedEntityInstance",
            value: widget.trackedEntityInstance?.trackedEntityInstance)
        .get();

    List<ProgramTrackedEntityAttribute> mandatoryTrackedEntityAttributes =
        widget.programAttributes
            .where((ProgramTrackedEntityAttribute attribute) {
      return attribute.mandatory == true;
    }).toList();


    List<ProgramTrackedEntityAttribute>
        mandatoryTrackedEntityAttributesWithNoData =
        mandatoryTrackedEntityAttributes
            .where((ProgramTrackedEntityAttribute attribute) {
      var attributeValue =
          getAttributeValue(attribute.attribute, upToDateTEIAttributeValues);

      if (attributeValue == "" || attributeValue == null) {
        return true;
      } else {
        return false;
      }
    }).toList();

    mandatoryTrackedEntityAttributesWithNoData
        .forEach((ProgramTrackedEntityAttribute element) {
      // print(element.displayName);
    });

    return mandatoryTrackedEntityAttributesWithNoData.length > 0 ? false : true;
  }

  getAttributeValue(
      String id, List<TrackedEntityAttributeValue> teiAttributes) {
    List<TrackedEntityAttributeValue> matchedAttributeValues =
        teiAttributes == null
            ? []
            : (teiAttributes as List<TrackedEntityAttributeValue>)
                .where((TrackedEntityAttributeValue attributeValue) {
                return attributeValue.attribute == id;
              }).toList();

    return matchedAttributeValues.length > 0
        ? matchedAttributeValues[0].value
        : null;
  }

  showSavingOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: FutureBuilder(
                future: canComplete(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close_outlined),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            widget.disableCompleting == true ||
                                    snapshot.data == false
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black12)),
                                          child: const Text(
                                            'COMPLETE AND SAVE',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          child:
                                              const Text('COMPLETE AND SAVE'),
                                          onPressed: () {
                                            completeAndNavigate();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text('SAVE'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          Text("Compiling data"),
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.black12,
                            color: Theme.of(context).colorScheme.primary,
                            // valueColor: Colors.blue,
                          )
                        ],
                      ),
                    );
                  }
                }),
          ),
        );
      },
    );
  }

  Future<List> getTrackerFormSections() async {
    if (widget.trackedEntityInstance == null) {
      // initiatilize new trackedEntity instance when is a new case
      final TrackedEntityInstance trackedentityinstanceObject = await D2Touch
          .trackerModule.trackedEntityInstance
          .byProgram(widget.programId.toString())
          .byOrgUnit(widget.selectedOrgUnit!.id.toString())
          .create();

      List<Enrollment> enrollments = await D2Touch.trackerModule.enrollment.where(attribute: "trackedEntityInstance", value: trackedentityinstanceObject.trackedEntityInstance).get();

      if(enrollments.length > 0){

        enrollments[0].enrollmentDate = (enrollments[0].enrollmentDate as String).split(".")[0];
        enrollments[0].incidentDate = (enrollments[0].incidentDate as String).split(".")[0];

        await D2Touch.trackerModule.enrollment.setData(enrollments[0]).save();

      }

      widget.trackedEntityInstance = trackedentityinstanceObject;
      trackerformSections = formSections();
    } else {
      trackerformSections = formSections();
    }

    if (programRuleActions.length == 0) {
      TrackerRuleResult trackerRuleResult = await TrackerRuleEngine.execute(
          trackedEntityInstance:
              widget.trackedEntityInstance as TrackedEntityInstance,
          program: widget.programId);

      applyRules(trackerRuleResult);
    }

    return trackerformSections;
  }

  Future<void> completeAndNavigate() async {
    List<Enrollment> enrollments = await D2Touch.trackerModule.enrollment
        .where(
            attribute: "trackedEntityInstance",
            value:
                widget.trackedEntityInstance?.trackedEntityInstance as String)
        .get();

    if (enrollments.length > 0) {
      enrollments[0].status = "COMPLETED";

      await D2Touch.trackerModule.enrollment.setData(enrollments[0]).save();
    } else {
      Enrollment enrollment = new Enrollment(
          trackedEntityInstance:
              widget.trackedEntityInstance?.trackedEntityInstance as String,
          trackedEntityType:
              widget.trackedEntityInstance?.trackedEntityType as String,
          orgUnit: widget.trackedEntityInstance?.orgUnit as String,
          program: widget.programId,
          dirty: true,
          status: "COMPLETED");

      await D2Touch.trackerModule.enrollment.setData(enrollment).save();
    }

    Navigator.pop(context);

    Navigator.pop(context);
  }

  applyRules(TrackerRuleResult trackerRuleResult) {
    // way to merge into array of p_rule_actions
    trackerRuleResult.programRuleActions.forEach((ProgramRuleAction action) {
      // check if the action for the attribute already exists
      List<ProgramRuleAction> existingActionForAttribute =
          programRuleActions.where((ProgramRuleAction existingAction) {
        return existingAction.trackedEntityAttribute ==
            action.trackedEntityAttribute;
      }).toList();

      if (existingActionForAttribute.length > 0) {
        // replace the action with the latest
        programRuleActions.removeWhere((ProgramRuleAction existingAction) {
          return existingAction.trackedEntityAttribute ==
              action.trackedEntityAttribute;
        });

        setState(() {
          programRuleActions.add(action);
        });
      } else {
        // add the action
        setState(() {
          programRuleActions.add(action);
        });
      }
    });
  }

  formSections() {
    return widget.trackerformSection
        .map((formSection) => updateFormSection(formSection))
        .toList();
  }

  updateFieldData(field) {
    List<ProgramTrackedEntityAttribute>? filteredAttribute = widget
        .programAttributes
        .where((item) => item.attribute == field['id'])
        .toList();
    return filteredAttribute.length > 0 ? filteredAttribute[0] : {};
  }

  updateFieldGroupData(fieldGroup) {
    final updatedFields = (fieldGroup['fields'] ?? [])
        .map((field) => updateFieldData(field))
        .toList();
    return {...fieldGroup, 'fields': updatedFields};
  }

  updateFormSection(formSection) {
    final updatedFieldGroups = (formSection['fieldGroups'] ?? [])
        .map((fieldGroup) => updateFieldGroupData(fieldGroup))
        .toList();
    return {...formSection, "fieldGroups": updatedFieldGroups};
  }

  Future<void> showActionsDialog(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );
    setState(() {
      widget.selectedOrgUnit = result[0];
    });
  }

  Future<String> dataEntryOUtoDisplay(List<Enrollment>? enrollments) async {
    if (enrollments == null) {
      String ouToDisplay = widget.selectedOrgUnit!.name ?? 'No Orgunit';
      return ouToDisplay;
    } else {
      final enrollment = enrollments[0];
      String orgUnitId = enrollment.orgUnit.toString();
      OrganisationUnit organisationUnit =
          await OrganisationUnitQuery().byId(orgUnitId).getOne();
      return organisationUnit.name as String;
      // return orgUnitId;
    }
  }

  Future<String> getOrgunitName(String id) async {
    OrganisationUnit organisationUnit =
        await OrganisationUnitQuery().byId(id).getOne();

    return organisationUnit.name as String;
  }
}
