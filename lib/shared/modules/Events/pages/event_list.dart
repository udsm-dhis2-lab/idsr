import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage.entity.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/modules/Events/widgets/event_list_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'event_form.dart';

class EventList extends StatefulWidget {
  final String stageUuid;
  final List<dynamic> stageSummaryConfigurations;
  final String eventProgramTitle;
  final OrganisationUnit selectedOrgunit;
  final bool? showBottomAddButton;
  final int? maxEventsOnList;
  final bool? showStageTitle;
  final bool fullPageLoader;
  final TrackedEntityInstance? trackedEntityInstance;
  final String programId;

  const EventList(
      {Key? key,
      required this.eventProgramTitle,
      required this.stageUuid,
      required this.stageSummaryConfigurations,
      this.showBottomAddButton,
      this.trackedEntityInstance,
      this.maxEventsOnList,
      this.showStageTitle,
      this.fullPageLoader: false,
      required this.selectedOrgunit,
      required this.programId})
      : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  late AnimationController circularController;

  @override
  void initState() {
    super.initState();
    circularController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        // setState(() {});
      });
    circularController.repeat(reverse: true);
  }

  @override
  void dispose() {
    circularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStageEventsList(
            widget.stageUuid, widget.selectedOrgunit.id as String),
        builder: (context, snapshot) {
          // print("the data received");
          // print(snapshot.data);
          if (snapshot.hasData && snapshot.data != null) {
            return Column(children: [
              widget.showStageTitle == true
                  ? Container(
                      padding: EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(widget.eventProgramTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: AppColors.blueThemeColor)))
                        ],
                      ))
                  : SizedBox(
                      height: 0,
                    ),
              ...(snapshot.data as List<Event>).length == 0
                  ? [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("No events created")],
                      )
                    ]
                  : [
                      ...(snapshot.data as List<Event>)
                          .map((event) => GestureDetector(
                              onTap: () {
                                openEventToEdit(event);
                              },
                              child: EventListCard(
                                  title: widget.eventProgramTitle,
                                  event: event,
                                  stageUuid: widget.stageUuid,
                                  // TODO: replace with configrable summary configs
                                  summaryConfigs:
                                      widget.stageSummaryConfigurations,
                                  programId: widget.programId)))
                          .toList()
                    ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.showBottomAddButton == true
                    ? [
                        TextButton.icon(
                            onPressed: () {
                              addNewEvent();
                            },
                            // style: ButtonStyle(
                            //     backgroundColor: MaterialStateProperty.all(
                            //         Theme.of(context).colorScheme.secondary)),
                            label: Text(
                              "New",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.primary,
                            ))
                      ]
                    : [],
              ),
            ]);
          } else {
            return widget.fullPageLoader == true
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            left: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2))),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15,
                        left: 30,
                        right: 30),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: Colors.black12,
                                  color: Theme.of(context).colorScheme.primary,
                                  // valueColor: Colors.blue,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Loading Reports...',
                                  style:
                                      TextStyle(color: AppColors.textPrimary),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Column(
                    children: [
                      CircularProgressIndicator(
                        value: circularController.value,
                      ),
                      Text('Loading data..')
                    ],
                  ));
          }
        });
  }

  Future<List<Event>> getStageEventsList(
      String stageId, String organisationUnitId) async {
    // print("i get called");

    if (widget.trackedEntityInstance != null) {
      List<Event> events = [];

      // print("here");

      if (widget.trackedEntityInstance?.enrollments != null) {
        // print("here 2");
        List<Event>? teiEvents = await D2Touch.trackerModule.event
            .withDataValues()
            .byEnrollment(widget
                .trackedEntityInstance?.enrollments?[0]?.enrollment as String)
            .byProgramStage(widget.stageUuid)
            .get();

        // print("here 3");
        // print(teiEvents);


        // TODO revert this code and crosscheck the logic
        /*if (teiEvents.length == 0) {

          // print("enter there");
          // print(widget
              .trackedEntityInstance?.enrollments?[0]?.enrollment);
          // print(widget.stageUuid);
          List<Event>? teiDownloadedEvents = await D2Touch.trackerModule.event
              .withDataValues()
              .byEnrollment(widget
                  .trackedEntityInstance?.enrollments?[0]?.enrollment as String)
              .byProgramStage(widget.stageUuid)
              .download((p0, p1) {});

          // print("there 1");
          // print(teiDownloadedEvents);

          teiEvents = await D2Touch.trackerModule.event
              .withDataValues()
              .byEnrollment(widget
                  .trackedEntityInstance?.enrollments?[0]?.enrollment as String)
              .byProgramStage(widget.stageUuid)
              .get();


          // print("there 2");
          // print(teiEvents);
        }
        */

        // print("here 4");

        if (teiEvents != null) {
          events.addAll(teiEvents as List<Event>);
        }

        // print("here5");
      }

      // print("here 6");
      return events;
    } else {
      ProgramStage programStage = await D2Touch.programModule.programStage
          .withDataElements()
          .byId(stageId)
          .getOne();

      List<Event> data = await D2Touch.trackerModule.event
          .withDataValues()
          .where(attribute: "programStage", value: stageId)
          .where(attribute: "orgUnit", value: organisationUnitId)
          .get();

      if (data.length == 0) {
        try {
          await D2Touch.trackerModule.event
              .byProgram(programStage.program)
              .byProgramStage(stageId)
              .byOrgUnit(organisationUnitId)
              .download((p0, p1) {});

          data = await D2Touch.trackerModule.event
              .withDataValues()
              .where(attribute: "programStage", value: stageId)
              .where(attribute: "orgUnit", value: organisationUnitId)
              .get();
        } catch (e) {}
      }

      return data;
    }
  }

  Future<void> openEventToEdit(Event eventToEdit) async {
    ProgramStage? programStage = await D2Touch.programModule.programStage
        .withDataElements()
        // .withSections()
        // .byId("PXsALJ60dF3")
        .getOne();

    Program program = await D2Touch.programModule.program
        .withProgramStages()
        .byId("A3olldDSHQg")
        .getOne();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventForm(
                  programId: widget.programId,
                  title: widget.eventProgramTitle,
                  stageUuid: widget.stageUuid,
                  event: eventToEdit,
                  organisationUnit: widget.selectedOrgunit,
                  // programStage: programStage as ProgramStage,
                )));
  }

// TODO: add logic to generate a blank event to pass to the widget
  Future<void> addNewEvent() async {
    Event eventToAdd;
    if (widget.trackedEntityInstance == null) {
      eventToAdd = await D2Touch.trackerModule.event
          .byProgramStage(widget.stageUuid)
          .byOrgUnit(widget.selectedOrgunit.id as String)
          .create();
    } else {
      eventToAdd = await D2Touch.trackerModule.event
          .byProgramStage(widget.stageUuid)
          .byOrgUnit(widget.selectedOrgunit.id as String)
          .byEnrollment(widget.trackedEntityInstance?.enrollments?[0].enrollment
              as String)
          .create();

      eventToAdd.trackedEntityInstance =
          widget.trackedEntityInstance?.enrollments?[0].enrollment as String;
      //TODO: associate with tei on creation using enrollment -SDK
      await D2Touch.trackerModule.event.setData(eventToAdd).save();
    }

    //TODO get event metadata
    ProgramStage? programStage = await D2Touch.programModule.programStage
        .withDataElements()
        .byId(widget.stageUuid)
        .getOne();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventForm(
                programId: widget.programId,
                title: widget.eventProgramTitle,
                stageUuid: widget.stageUuid,
                event: eventToAdd
                // event: eventToEdit,
                // programStage: programStage as ProgramStage,
                )));
  }
}
