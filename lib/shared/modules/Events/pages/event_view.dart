import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/tracker/entities/event_data_value.entity.dart';
import 'package:d2_touch/modules/metadata/data_element/entities/data_element.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage_data_element.entity.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/modules/Events/widgets/event_list_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';

import 'event_form.dart';

class EventView extends StatefulWidget {
  final List<dynamic> summaryConfigurations;
  final Event event;
  final String title;
  final String programId;

  const EventView(
      {Key? key,
      required this.title,
      required this.event,
      required this.summaryConfigurations,
      required this.programId})
      : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  double topSelectionHeight = 60;
  int? expandedIndex = 0;
  AppBar eventViewAppBar = AppBar(
    title: Text('Event View'),
  );

  @override
  void initState() {
    eventViewAppBar = AppBar(
      title: Text('${widget.title == null ? 'Event View' : widget.title}'),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: eventViewAppBar,
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: AppColors.whiteSmoke,
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      height: topSelectionHeight,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 8, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              TextButton.icon(
                                icon: Icon(
                                  Icons.date_range,
                                  color: AppColors.textMuted,
                                ),
                                label: Text(
                                  widget.event.eventDate != null
                                      ? sanitizedDateFormat(
                                          widget.event.eventDate as String)
                                      : "date not selected",
                                  style: TextStyle(
                                      fontSize: 15, color: AppColors.textMuted),
                                ),
                                onPressed: null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              TextButton.icon(
                                label: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                icon: Icon(Icons.edit_outlined),
                                onPressed: () {
                                  navigateToFormToEdit(widget.event);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                      // 166 was the overflowing pixels
                      height: MediaQuery.of(context).size.height -
                          (eventViewAppBar.preferredSize.height +
                              topSelectionHeight +
                              MediaQuery.of(context).padding.top +
                              MediaQuery.of(context).padding.bottom),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          FutureBuilder(
                              future: fetchOrgunitName(widget.event.orgUnit),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Container(
                                    padding: EdgeInsets.only(left: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(snapshot.data as String,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Loading facilty name",
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                  );
                                }
                              }),
                          FutureBuilder(
                            future: getSummaryConfigurations(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 5, right: 5, bottom: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [],
                                          )),
                                      Container(
                                        child: ExpansionPanelList(
                                          expansionCallback:
                                              (int index, bool isExpanded) {
                                            setState(() {
                                              // (snapshot.data as List<SectionedView>)[index].expanded = true;
                                              if (expandedIndex == index) {
                                                expandedIndex = null;
                                              } else {
                                                expandedIndex = index;
                                              }
                                              ;
                                            });
                                          },
                                          children: (snapshot.data
                                                  as List<SectionedView>)
                                              .map((SectionedView
                                                  sectionedView) {
                                            return ExpansionPanel(
                                                canTapOnHeader: true,
                                                headerBuilder:
                                                    (BuildContext context,
                                                        bool isExpanded) {
                                                  return Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          left: 5,
                                                          bottom: 10,
                                                          right: 5),
                                                      child: Text(
                                                          sectionedView.name));
                                                },
                                                // body: Text(sectionedView.name),
                                                body: Column(
                                                  children: [
                                                    ...sectionedView
                                                        .dataElements
                                                        .map((ProgramStageDataElement
                                                            programStageDataElement) {
                                                      return Container(
                                                          child:
                                                              Column(children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  bottom: 10),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  programStageDataElement
                                                                          .name
                                                                      as String,
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .textMuted,
                                                                      fontSize:
                                                                          10),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  getEventDataValue(
                                                                      programStageDataElement
                                                                          .dataElementId),
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis))
                                                            ],
                                                          ),
                                                        ),
                                                        Divider()
                                                      ]));
                                                    })
                                                  ],
                                                ),
                                                isExpanded:
                                                    sectionedView.index ==
                                                        expandedIndex);
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Text("loading data ...");
                              }
                            },
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<String> fetchOrgunitName(orgUnitId) async {
    List<OrganisationUnit>? organisationUnits = await D2Touch
        .organisationUnitModule.organisationUnit
        .byId(orgUnitId)
        .get();

    if (organisationUnits != null) {
      return organisationUnits[0].name as String;
    }

    return "";
  }

  Future<List<SectionedView>> getSummaryConfigurations() async {
    List<ProgramStageDataElement> programStageDataElements = await D2Touch
        .programModule.programStageDataElement
        .where(attribute: "programStage", value: widget.event.programStage)
        .get();

    // print("step 1");
    List<dynamic> sectionsConfigs =
        AppConstants.formSections[widget.event.programStage];

    // print("step 2");
    // print(sectionsConfigs);

    // List<dynamic> listDynamic = [...widget.summaryConfigurations];

    List<SectionedView> dataElementSections =
        sectionsConfigs.asMap().entries.map((section) {
      // print(1);
      List<ProgramStageDataElement> dataElements = [];
      //
      try {
        dataElements =
            section.value["dataElements"].forEach((dynamic dataElement) {
          List<ProgramStageDataElement> programStageDataElement =
              programStageDataElements.where((ProgramStageDataElement element) {
            return element.dataElementId == dataElement['id'];
          }).toList();

          // TODO: improve to return an instance of programStageDataElements
          ProgramStageDataElement programStageDataElementToAdd =
              programStageDataElement.length > 0
                  ? programStageDataElement[0]
                  : ProgramStageDataElement(
                      id: "",
                      name: "",
                      shortName: "",
                      dataElementId: "",
                      aggregationType: "",
                      domainType: "",
                      valueType: "",
                      dirty: false);

          dataElements.add(programStageDataElementToAdd);
        }).toList();
      } catch (e) {}
      ;

      List<ProgramStageDataElement> nonNullDataElements = dataElements
          .where(
              (ProgramStageDataElement element) => element.dataElementId != "")
          .toList();

      return SectionedView(
          name: section.value['name'],
          dataElements: nonNullDataElements,
          index: section.key);
    }).toList();

    return dataElementSections;
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

      return eventDataValue.length > 0 ? eventDataValue[0].value : "-";
    }
  }

  Future<void> navigateToFormToEdit(Event event) async {
    OrganisationUnit eventOrgunit = await D2Touch
        .organisationUnitModule.organisationUnit
        .byId(event.orgUnit as String)
        .getOne();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventForm(
              programId: widget.programId,
                  title: widget.title,
                  stageUuid: event.programStage,
                  event: event,
                  organisationUnit: eventOrgunit,
                )));
  }

  sanitizedDateFormat(String dateString) {
    DateTime sanitizedDate = DateTime.parse(dateString);

    return '${sanitizedDate.year.toString()}-${sanitizedDate.month.toString().padLeft(2, '0')}-${sanitizedDate.day.toString().padLeft(2, '0')}';
  }
}

class SectionedView {
  final String name;
  final int index;
  final List<ProgramStageDataElement> dataElements;
  bool expanded;

  SectionedView(
      {required this.name,
      required this.dataElements,
      required this.index,
      this.expanded: false});
}
