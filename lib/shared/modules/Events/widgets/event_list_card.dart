import 'dart:convert';

import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/tracker/entities/enrollment.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/event_data_value.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/modules/Events/pages/event_form.dart';
import 'package:eIDSR/shared/modules/Events/pages/event_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventListCard extends StatefulWidget {
  final Event event;
  final List<dynamic> summaryConfigs;
  final String stageUuid;
  final String title;
  final String programId;
  final bool hideViewButton;
  final bool hideEditButton;

  const EventListCard(
      {Key? key,
      required this.event,
      required this.summaryConfigs,
      required this.stageUuid,
      required this.title,
      this.hideEditButton: false,
      this.hideViewButton: false,
      required this.programId})
      : super(key: key);

  @override
  _EventListCardState createState() => _EventListCardState();
}

class _EventListCardState extends State<EventListCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool synchronizing = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                        widget.event.eventDate == null
                            ? ""
                            : sanitizedDateFormat(
                                widget.event.eventDate as String),
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none)),
                  ],
                ),
                Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: synchronizing == true
                            ? RotationTransition(
                                turns: _animation,
                                child: IconButton(
                                    icon: Icon(
                                      widget.event.synced == false &&
                                              widget.event.syncFailed != true
                                          ? Icons.sync_rounded
                                          : widget.event.syncFailed == true
                                              ? Icons.sync_problem
                                              : widget.event.synced == true
                                                  ? Icons.check_circle_outline
                                                  : Icons.sync_problem,
                                      color: widget.event.synced == false &&
                                              widget.event.syncFailed != true
                                          ? Colors.blueAccent
                                          : widget.event.syncFailed == true
                                              ? AppColors.textDanger
                                              : widget.event.synced == true
                                                  ? AppColors.textSuccess
                                                  : AppColors.textMuted,
                                    ),
                                    tooltip: 'Sync',
                                    onPressed: widget.event.synced == false &&
                                            widget.event.syncFailed == false
                                        ? () {
                                            setState(() {
                                              synchronizing = true;
                                            });
                                            synchroniseEventData(widget.event);
                                          }
                                        : () {}))
                            : IconButton(
                                icon: Icon(
                                  widget.event.synced == false &&
                                          widget.event.syncFailed != true
                                      ? Icons.sync_rounded
                                      : widget.event.syncFailed == true
                                          ? Icons.sync_problem
                                          : widget.event.synced == true
                                              ? Icons.check_circle_outline
                                              : Icons.sync_problem,
                                  color: widget.event.synced == false &&
                                          widget.event.syncFailed != true
                                      ? Colors.blueAccent
                                      : widget.event.syncFailed == true
                                          ? AppColors.textDanger
                                          : widget.event.synced == true
                                              ? AppColors.textSuccess
                                              : AppColors.textMuted,
                                ),
                                tooltip: 'Sync',
                                onPressed:
                                    /*widget.event.synced == false &&
                                        widget.event.syncFailed == false
                                    ? */
                                    () {
                                  setState(() {
                                    synchronizing = true;
                                  });
                                  synchroniseEventData(widget.event);
                                }
                                //: () {}
                                ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                    children: widget.summaryConfigs.map((dynamic config) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(config['label'],
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.none)),
                      ),
                      Expanded(
                        flex: 3,
                        child: config["id"] == "orgUnit"
                            ? FutureBuilder(
                                future: getOrgunitName(widget.event.orgUnit),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return Text(
                                        snapshot.data as String, // caseID
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none));
                                  } else {
                                    return Text("", // caseID
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none));
                                  }
                                })
                            : Text(getEventDataValue(config["id"]), // caseID
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none)),
                      )
                    ],
                  );
                }).toList())),

            // Divider(),
            Container(
                padding: EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.hideEditButton == false
                        ? TextButton(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () {
                              navigateToFormToEdit(widget.event);
                            },
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    widget.hideViewButton == false
                        ? TextButton(
                            child: Text(
                              'View',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () {
                              // navigateWithData
                              navigateToFormView(widget.event);
                            },
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  navigateToFormToEdit(Event event) async {
    OrganisationUnit eventOrgunit = await D2Touch
        .organisationUnitModule.organisationUnit
        .byId(widget.event.orgUnit as String)
        .getOne();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventForm(
                  title: widget.title,
                  stageUuid: widget.stageUuid,
                  event: event,
                  programId: widget.programId,
                  organisationUnit: eventOrgunit,
                )));
  }

  navigateToFormView(Event event) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventView(
                programId: widget.programId,
                title: widget.title,
                event: event,
                summaryConfigurations: widget.summaryConfigs)));
  }

  sanitizedDateFormat(String dateString) {
    DateTime sanitizedDate = DateTime.parse(dateString);

    return '${sanitizedDate.year.toString()}-${sanitizedDate.month.toString().padLeft(2, '0')}-${sanitizedDate.day.toString().padLeft(2, '0')}';
  }

  String getEventDataValue(String dataElementId) {
    List<EventDataValue> eventDataValue =
        (widget.event.dataValues as List<EventDataValue>)
            .toList()
            .where((data) {
      return data.dataElement == dataElementId;
    }).toList();

    return eventDataValue.length > 0 ? eventDataValue[0].value : "";
  }

  Future<String> getOrgunitName(String id) async {
    OrganisationUnit organisationUnit =
        await OrganisationUnitQuery().byId(id).getOne();

    return organisationUnit.name as String;
  }

  Future<Event> synchroniseEventData(Event event) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Synchronizing Event'),
      backgroundColor: AppColors.bgPrimary,
    ));

    // print("event enrollment");
    if (event.enrollment != null && event.enrollment != "") {
      Enrollment? enrollment = await D2Touch.trackerModule.enrollment
          .byId(event.enrollment)
          .getOne();
      event.trackedEntityInstance =
          (enrollment?.trackedEntityInstance as String);
      await D2Touch.trackerModule.event.setData(event).save();
    }

    try {
      //TODO: for tracker events add mechanism to check if tei is synced

      // print("this way");
      List<Event>? eventUploadResponse = await D2Touch.trackerModule.event
          .byId(event.id as String)
          .upload((p0, p1) {
        // print(p0);
        // print(p1);
      });

      if (eventUploadResponse?[0].syncFailed == true) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Synchronization Failed'),
        //   backgroundColor: AppColors.textDanger,
        // ));
        //

        showErrorOnBottomSheet(eventUploadResponse?[0] as Event);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Synchronization Succesful'),
          backgroundColor: AppColors.textSuccess,
        ));
      }

      if (eventUploadResponse != null) {
        setState(() {
          synchronizing = false;
          widget.event.syncFailed = eventUploadResponse[0].syncFailed;
          widget.event.synced = eventUploadResponse[0].synced;
          widget.event.lastSyncSummary = eventUploadResponse[0].lastSyncSummary;
          widget.event.lastSyncDate = eventUploadResponse[0].lastSyncDate;
        });
      }
    } catch (e) {
      // print(e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Synchronization Failed'),
      //   backgroundColor: AppColors.textDanger,
      // ));

      // TODO the event is the original one, not manipulated - imporve this
      showErrorOnBottomSheet(widget.event);

      setState(() {
        synchronizing = false;
      });
    }

    return event;
  }

  void showErrorOnBottomSheet(Event event) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.textDanger,
                          size: 25,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "There was an error saving data",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textDanger),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Message : " +
                              (event.lastSyncSummary != null &&
                                      event.lastSyncSummary != ""
                                  ? event.lastSyncSummary as String
                                  : ""),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: AppColors.textDanger),
                        ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
