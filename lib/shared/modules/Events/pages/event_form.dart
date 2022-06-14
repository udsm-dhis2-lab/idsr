import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/event_data_value.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:d2_touch/modules/data/tracker/queries/event.query.dart';
import 'package:d2_touch/modules/data/tracker/queries/event_data_value.query.dart';
import 'package:d2_touch/modules/engine/program_rule/event_rule_engine.dart';
import 'package:d2_touch/modules/engine/program_rule/models/event_rule_result.model.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_rule_action.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage_data_element.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage_data_element_option.entity.dart';
import 'package:d2_touch/shared/utilities/sort_order.util.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/model/option.model.dart';
import 'package:eIDSR/shared/widgets/form/generic_field_input.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';
import 'package:eIDSR/shared/widgets/text_widgets/app_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventForm extends StatefulWidget {
  final String stageUuid;
  final TrackedEntityInstance? trackedEntityInstance;
  final OrganisationUnit? organisationUnit;
  final String programId;
  final Event? event;
  final String title;

  const EventForm(
      {Key? key,
      required this.programId,
      required this.stageUuid,
      this.organisationUnit: null,
      this.trackedEntityInstance: null,
      this.event: null,
      required this.title})
      : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  String dateLable = "Event Date";
  List<ProgramRuleAction> programRuleActions = [];

  @override
  Widget build(BuildContext context) {
    if (widget.event?.eventDate != null && widget.event?.eventDate != "") {
      setState(() {
        dateLable = widget.event?.eventDate as String;
      });
    }

    AppBar trackerAppBar = new AppBar(
      title: Text(widget.title),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: trackerAppBar,
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
                              // height: 60,
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextButton.icon(
                                          icon: Icon(
                                            Icons.account_tree_outlined,
                                            color: AppColors.textMuted,
                                          ),
                                          label: Text(
                                            widget.organisationUnit == null
                                                ? "Select Facility"
                                                : ((widget.organisationUnit
                                                        as OrganisationUnit)
                                                    .name as String),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors.textMuted,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          onPressed: () {
                                            navigateToOrgUnitSelector(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(top: 15, left: 10, right: 10),
                              // 166 was the overflowing pixels
                              // height: MediaQuery.of(context).size.height -
                              //     (trackerAppBar.preferredSize.height + 160),
                              child: FutureBuilder(
                                future: getProgramStageMetadata(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            TextButton.icon(
                                                onPressed: () {
                                                  popDatePicker(context);
                                                },
                                                icon: Icon(Icons.today),
                                                label: Text(dateLable))
                                          ],
                                        ),
                                        ...(snapshot.data
                                                as List<EventFormSection>)
                                            .map((EventFormSection data) {
                                          return Card(
                                            child: ClipPath(
                                              child: Container(
                                                // height: 100,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color: AppColors
                                                                .blueThemeColor,
                                                            width: 5))),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10, left: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            data.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 18,
                                                                color: AppColors
                                                                    .blueThemeColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    // Divider()
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            children: (data
                                                                        .dataElements
                                                                    as List<
                                                                        ProgramStageDataElement>)
                                                                .map((ProgramStageDataElement
                                                                    dataElement) {
                                                              return showField(
                                                                          dataElement
                                                                              .dataElementId) ==
                                                                      false
                                                                  ? SizedBox(
                                                                      height: 0,
                                                                      width: 0,
                                                                    )
                                                                  : widget.event !=
                                                                          null
                                                                      ? GenericFieldInput(
                                                                          options: dataElement.options ==
                                                                                  null
                                                                              ? []
                                                                              : (dataElement.options as List<ProgramStageDataElementOption>).map(
                                                                                  (dataElementOption) {
                                                                                  return new DataOption(name: dataElementOption.name as String, code: dataElementOption.code as String);
                                                                                }).toList(),
                                                                          inputValue: getEventDataValue(dataElement
                                                                              .dataElementId),
                                                                          displayName: dataElement.name
                                                                              as String,
                                                                          valueType: dataElement
                                                                              .valueType,
                                                                          field: dataElement
                                                                              .dataElementId,
                                                                          onFieldInputChanged:
                                                                              (String field, dynamic value) {
                                                                            onFieldInputChanged(field,
                                                                                value);
                                                                          })
                                                                      : GenericFieldInput(
                                                                          options: dataElement.options == null
                                                                              ? []
                                                                              : (dataElement.options as List<ProgramStageDataElementOption>).map((dataElementOption) {
                                                                                  return new DataOption(name: dataElementOption.name as String, code: dataElementOption.code as String);
                                                                                }).toList(),
                                                                          displayName: dataElement.name as String,
                                                                          valueType: dataElement.valueType,
                                                                          field: dataElement.dataElementId,
                                                                          onFieldInputChanged: (String field, dynamic value) {
                                                                            onFieldInputChanged(field,
                                                                                value);
                                                                          });
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3))),
                                            ),
                                          );
                                        }).toList(),
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
                                                      // showSavingOptions();
                                                      // widget.event.
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("SAVE")),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
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
                                                    'Loading Form Configrations...',
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
                                },
                              ),
                            ),
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

  Future<List<EventFormSection>> getProgramStageMetadata() async {
    ProgramStage programStage = await D2Touch.programModule.programStage
        .withSections()
        .withDataElements()
        .byId(widget.stageUuid)
        .getOne();

    if (programStage.executionDateLabel != null) {
      setState(() {
        dateLable = (programStage.executionDateLabel as String);
      });
    }

    List<ProgramStageDataElement> programStageDataElements = await D2Touch
        .programModule.programStageDataElement
        .withOptions()
        .where(attribute: "programStage", value: widget.stageUuid)
        .get();

    List<EventFormSection> eventFormSections = groupDataElementsIntoSections(
        programStageDataElements, AppConstants.formSections[widget.stageUuid]);

    return eventFormSections;
  }

  List<EventFormSection> groupDataElementsIntoSections(
      List<ProgramStageDataElement> dataElements, List<dynamic> sections) {
    List<EventFormSection> eventFormSections = sections.map((dynamic section) {
      List<ProgramStageDataElement> programStageDataelements = [];

      programStageDataelements = (section['dataElements'] as List<dynamic>)
          .map((dynamic dataElement) {
            List<ProgramStageDataElement> programStageDataElements =
                dataElements.where((ProgramStageDataElement element) {
              return element.dataElementId == dataElement['id'] ? true : false;
            }).toList();

            return programStageDataElements.length > 0
                ? programStageDataElements[0]
                : new ProgramStageDataElement(
                    id: "",
                    name: "",
                    shortName: "",
                    dataElementId: "",
                    aggregationType: "",
                    domainType: "",
                    valueType: "",
                    dirty: false);
          })
          .where((element) => element.dataElementId != "")
          .toList();

      return new EventFormSection(
          name: section['name'], dataElements: programStageDataelements);
    }).toList();

    return eventFormSections;
  }

  Future<void> navigateToOrgUnitSelector(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );
  }

  Future<void> popDatePicker(context) async {
    DateTime today = DateTime.now();
    DateTime initialDate = today.subtract(Duration(days: 30));
    DateTime finalDate = today.add(Duration(days: 30));

    DateTime? selectedEventDate = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: initialDate,
        lastDate: finalDate);

    widget.event?.eventDate = selectedEventDate?.toIso8601String();

    await D2Touch.trackerModule.event.setData(widget.event).save();

    Event? updatedEvent = await D2Touch.trackerModule.event
        .byId(widget.event?.id as String)
        .getOne();
  }

  onFieldInputChanged(String field, dynamic value) async {
    final EventDataValue eventDataValue = EventDataValue(
      synced: false,
      dirty: true,
      dataElement: field,
      value: value,
      event: widget.event?.event as String,
      id: (widget.event?.event as String) + "_" + field,
      name: (widget.event?.event as String) + "_" + field,
    );

    var eventDataValueSaveResponse = await D2Touch.trackerModule.eventDataValue
        .setData(eventDataValue)
        .save();

    //execute ruled
    EventRuleResult eventRuleResult = await EventRuleEngine.execute(
        event: widget.event as Event, program: widget.programId);

    eventRuleResult.programRuleActions.forEach((element) {
      // print(element.dataElement);
      // print(element.programRuleActionType);
    });

    //merge rules
    applyRules(eventRuleResult);
  }

  applyRules(EventRuleResult eventRuleResult) {
    // way to merge into array of p_rule_actions
    eventRuleResult.programRuleActions.forEach((ProgramRuleAction action) {
      // check if the action for the attribute already exists
      List<ProgramRuleAction> existingActionForAttribute =
          programRuleActions.where((ProgramRuleAction existingAction) {
        return existingAction.dataElement == action.dataElement;
      }).toList();

      if (existingActionForAttribute.length > 0) {
        // replace the action with the latest
        programRuleActions.removeWhere((ProgramRuleAction existingAction) {
          return existingAction.dataElement == action.dataElement;
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

  String getEventDataValue(String dataElementId) {
    if ((widget.event as Event).dataValues == null) {
      return "";
    } else {
      List<EventDataValue> eventDataValue =
          ((widget.event as Event).dataValues as List<EventDataValue>)
              .toList()
              .where((data) {
        return data.dataElement == dataElementId;
      }).toList();

      return eventDataValue.length > 0 ? eventDataValue[0].value : "";
    }
  }

  showField(String id) {
    List<ProgramRuleAction> actionsMatchingDataElement =
        programRuleActions.where((ProgramRuleAction action) {
      return action.dataElement == id;
    }).toList();

    if (actionsMatchingDataElement.length == 0) {
      return true;
    } else {
      return actionsMatchingDataElement[0].programRuleActionType.toString() ==
              "HIDEFIELD"
          ? false
          : true;
    }
  }
}

class EventFormSection {
  final String name;
  final List<ProgramStageDataElement> dataElements;

  const EventFormSection({required this.name, required this.dataElements});
}
