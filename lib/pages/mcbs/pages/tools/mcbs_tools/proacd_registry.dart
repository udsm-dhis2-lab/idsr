import 'dart:io';

import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/event.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/queries/event.query.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_stage.entity.dart';
import 'package:eIDSR/pages/ibs/mcbs/pages/proacd_registry/proacd_registry_dataentry.dart';
import 'package:eIDSR/shared/modules/Events/pages/event_form.dart';
import 'package:eIDSR/shared/modules/Events/pages/event_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

class ProacdRegistry extends StatefulWidget {
  const ProacdRegistry({Key? key}) : super(key: key);

  @override
  _ProacdRegistryState createState() => _ProacdRegistryState();
}

class _ProacdRegistryState extends State<ProacdRegistry> {
  OrganisationUnit? selectedOrgUnit;

  AppBar ourAppBar = new AppBar(
    title: Text("Pro-ACD Register"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ourAppBar,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: selectedOrgUnit == null
              ? () {}
              : () {
                  addNewEvent();
                },
          backgroundColor: selectedOrgUnit == null
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            Container(
                width: double.maxFinite,
                color: AppColors.whiteSmoke,
                child: Column(children: [
                  Column(children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 8, right: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextButton.icon(
                                            icon: Icon(
                                                Icons.account_tree_outlined),
                                            label: selectedOrgUnit == null
                                                ? Text("Select Facility")
                                                : Text(
                                                    '${selectedOrgUnit?.name}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                            onPressed: () {
                                              navigateToOrgUnitSelector(
                                                  context);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: selectedOrgUnit == null
                                          ? () {}
                                          : () {
                                              addNewEvent();
                                            },
                                      icon: Icon(
                                        Icons.add,
                                        color: selectedOrgUnit == null
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                      label: Text(
                                        "New",
                                        style: TextStyle(
                                            color: selectedOrgUnit == null
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(top: 15, left: 10, right: 10),
                              child: selectedOrgUnit == null
                                  ? Container(
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
                                            children: [
                                              Text(
                                                  "No Facility Selected"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Select Facility to continue"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextButton.icon(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  primary: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  // minimumSize:
                                                  //     const Size.fromHeight(50)
                                                ),
                                                icon: Icon(Icons
                                                    .account_tree_outlined),
                                                label: selectedOrgUnit == null
                                                    ? Text("Select Facility")
                                                    : Text(
                                                        '${selectedOrgUnit?.name}',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                onPressed: () {
                                                  navigateToOrgUnitSelector(
                                                      context);
                                                },
                                              ),
                                            ]),
                                      ),
                                    )
                                  :
                                  // SingleChildScrollView(
                                  //         scrollDirection: Axis.vertical,
                                  //         child:
                                  EventList(
                                      showBottomAddButton: false,
                                      fullPageLoader: true,
                                      showStageTitle: false,
                                      eventProgramTitle: "Pro-ACD Registry",
                                      stageUuid: "PXsALJ60dF3",
                                      programId: "A3olldDSHQg",
                                      stageSummaryConfigurations: [
                                        {"id": "SgclPhIHo7d", "label": "Sex"},
                                        {"id": "orgUnit", "label": "Facility"},
                                        {
                                          "id": "CMJKuLcTdxK",
                                          "label": "Test results"
                                        },
                                        {
                                          "id": "re1kmrVDl51",
                                          "label": "First name"
                                        },
                                        {
                                          "id": "NPUz9Eb9vZH",
                                          "label": "Last name"
                                        },
                                      ],
                                      selectedOrgunit:
                                          selectedOrgUnit as OrganisationUnit)
                              // )
                              ),
                        ],
                      ),
                    ),
                  ]),
                ])),
          ],
        ));
  }

  // TODO: add logic to generate a blank event to pass to the widget
  Future<void> addNewEvent() async {
    // Event eventToAdd = await D2Touch.trackerModule.event.create();

    Event event = await D2Touch.trackerModule.event
        .byProgramStage("PXsALJ60dF3")
        .byOrgUnit(selectedOrgUnit?.id as String)
        .create();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventForm(
                  programId: "A3olldDSHQg",
                  title: "Pro-ACD ",
                  event: event,
                  stageUuid: 'PXsALJ60dF3',
                  organisationUnit: selectedOrgUnit,
                )));
  }

  Future<void> navigateToOrgUnitSelector(BuildContext context) async {
    setState(() {
      selectedOrgUnit = null;
    });

    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );

    setState(() {
      selectedOrgUnit = result[0];
    });
  }

  Future<OrganisationUnit?> getUserOrganisationUnit() async {
    List<OrganisationUnit>? userOrganisationsUnits =
        await OrganisationUnitQuery().getUserOrgUnits();

    List<OrganisationUnit> userOrganisationUnitsFinal =
        userOrganisationsUnits as List<OrganisationUnit>;
    if (userOrganisationUnitsFinal.length == 1) {
    } else {}

    return null;
  }

  Future<List<Event>> getEventsData() async {
    // TODO: delete events function for testing to be removed

    await D2Touch.trackerModule.event.delete();

    await D2Touch.trackerModule.event
        .byProgram("A3olldDSHQg")
        .byOrgUnit(selectedOrgUnit?.id as String)
        .download((p0, p1) {
      // print(p0);
      // print(p1);
    });

    // TODO: improve later to get events by progam
    final List<Event> data = await D2Touch.trackerModule.event
        .withDataValues()
        .where(attribute: "programStage", value: "PXsALJ60dF3")
        .where(attribute: "orgUnit", value: selectedOrgUnit?.id as String)
        .get();

    return data;
  }
}
