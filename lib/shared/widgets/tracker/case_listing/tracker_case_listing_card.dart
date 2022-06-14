import 'dart:convert';

import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/enrollment.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked_entity_attribute_value.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/queries/program_tracked_entity_attribute.query.dart';
import 'package:eIDSR/shared/model/case_listing_params_model.dart';
import 'package:eIDSR/shared/widgets/tracker/case_listing/tracker_case_view_card.dart';
import 'package:eIDSR/shared/widgets/tracker/data_entry/tracker_dataentry_form.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';

class TrackerCaseListing extends StatefulWidget {
  TrackedEntityInstance trackedEntityInstance;
  String programId;
  final trackerformSection;
  final caseListingAttributeParams;
  final bool hideEditButton;
  final bool hideViewButton;
  final bool disableCompleting;
  final bool editStagesOnly;
  final bool hideEnrollmentActiveness;

  TrackerCaseListing({
    Key? key,
    required this.trackedEntityInstance,
    required this.trackerformSection,
    required this.programId,
    required this.caseListingAttributeParams,
    this.hideViewButton: false,
    required this.disableCompleting,
    this.hideEditButton: false,
    this.editStagesOnly: false,
    this.hideEnrollmentActiveness: false,
  }) : super(key: key);

  @override
  State<TrackerCaseListing> createState() => _TrackerCaseListingState();
}

class _TrackerCaseListingState extends State<TrackerCaseListing>
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
  List<ProgramTrackedEntityAttribute> programAttributesMetadata = [];

  @override
  void initState() {
    super.initState();
    getProgramAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToViewTracker();
      },
      child: Card(
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
                          sanitizedDateFormat(
                              widget.trackedEntityInstance.enrollments),
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
                                        widget.trackedEntityInstance.synced ==
                                                    false &&
                                                widget.trackedEntityInstance
                                                        .syncFailed !=
                                                    true
                                            ? Icons.sync_rounded
                                            : widget.trackedEntityInstance
                                                        .syncFailed ==
                                                    true
                                                ? Icons.sync_problem
                                                : widget.trackedEntityInstance
                                                            .synced ==
                                                        true
                                                    ? Icons.check_circle_outline
                                                    : Icons.sync_problem,
                                        color: widget.trackedEntityInstance
                                                        .synced ==
                                                    false &&
                                                widget.trackedEntityInstance
                                                        .syncFailed !=
                                                    true
                                            ? Colors.blueAccent
                                            : widget.trackedEntityInstance
                                                        .syncFailed ==
                                                    true
                                                ? AppColors.textDanger
                                                : widget.trackedEntityInstance
                                                            .synced ==
                                                        true
                                                    ? AppColors.textSuccess
                                                    : AppColors.textMuted,
                                      ),
                                      tooltip: 'Sync',
                                      onPressed: widget.trackedEntityInstance
                                                      .synced ==
                                                  false &&
                                              widget.trackedEntityInstance
                                                      .syncFailed ==
                                                  false
                                          ? () {
                                              setState(() {
                                                synchronizing = true;
                                              });
                                              synchroniseTrackedEntityInstanceData(
                                                  widget.trackedEntityInstance);
                                            }
                                          : () {}))
                              : IconButton(
                                  icon: Icon(
                                    widget.trackedEntityInstance.synced ==
                                                false &&
                                            widget.trackedEntityInstance
                                                    .syncFailed !=
                                                true
                                        ? Icons.sync_rounded
                                        : widget.trackedEntityInstance
                                                    .syncFailed ==
                                                true
                                            ? Icons.sync_problem
                                            : widget.trackedEntityInstance
                                                        .synced ==
                                                    true
                                                ? Icons.check_circle_outline
                                                : Icons.sync_problem,
                                    color:
                                        widget.trackedEntityInstance.synced ==
                                                    false &&
                                                widget.trackedEntityInstance
                                                        .syncFailed !=
                                                    true
                                            ? Colors.blueAccent
                                            : widget.trackedEntityInstance
                                                        .syncFailed ==
                                                    true
                                                ? AppColors.textDanger
                                                : widget.trackedEntityInstance
                                                            .synced ==
                                                        true
                                                    ? AppColors.textSuccess
                                                    : AppColors.textMuted,
                                  ),
                                  tooltip: 'Sync',
                                  onPressed:
                                      /*widget.trackedEntityInstance.synced ==
                                                  false &&
                                              widget.trackedEntityInstance
                                                      .syncFailed ==
                                                  false
                                          ? */
                                          () {
                                              setState(() {
                                                synchronizing = true;
                                              });
                                              synchroniseTrackedEntityInstanceData(
                                                  widget.trackedEntityInstance);
                                            }),
                                          // : () {}),
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
                  children: [...renderCaseDetails()],
                ),
              ),
              // Divider(),
              Container(
                padding: EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.hideEnrollmentActiveness == true
                        ? Text("")
                        : Text(
                            sanitizedEnrollmentStatus(
                                    widget.trackedEntityInstance.enrollments)
                                .toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSuccess,
                                decoration: TextDecoration.none)),
                    Row(
                      children: [
                        widget.hideEditButton == true
                            ? SizedBox(
                                height: 0,
                              )
                            : TextButton(
                                // icon: Icon(Icons.visibility_outlined),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                onPressed: () {
                                  // navigateWithData
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrackerDataEntryForm(
                                                disableCompleting: widget.disableCompleting,
                                                  programId: widget.programId,
                                                  trackerformSection:
                                                      widget.trackerformSection,
                                                  programAttributes:
                                                      programAttributesMetadata,
                                                  trackedEntityInstance: widget
                                                      .trackedEntityInstance)));
                                },
                              ),
                        widget.hideViewButton == true
                            ? SizedBox(
                                height: 0,
                                width: 0,
                              )
                            : TextButton(
                                // icon: Icon(Icons.visibility_outlined),
                                child: Text(
                                  'View',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                onPressed: () {
                                  // navigateWithData
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewTrackerCase(
                                              editStagesOnly:
                                                  widget.editStagesOnly,
                                              programId: widget.programId,
                                              trackerformSection:
                                                  widget.trackerformSection,
                                              programAttributes:
                                                  programAttributesMetadata,
                                              trackedEntityInstance: widget
                                                  .trackedEntityInstance)));
                                },
                              )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  navigateToViewTracker() async {
    List<ProgramTrackedEntityAttribute> programTrackedEntityAttributes =
        await D2Touch.programModule.programTrackedEntityAttribute
            .where(attribute: "program", value: widget.programId)
            .get();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewTrackerCase(
                  editStagesOnly: widget.editStagesOnly,
                  trackedEntityInstance: widget.trackedEntityInstance,
                  programId: widget.programId,
                  trackerformSection: [],
                  programAttributes: programTrackedEntityAttributes != null
                      ? programTrackedEntityAttributes
                      : [],
                  // programStage: programStage as ProgramStage,
                )));
  }

  sanitizedDateFormat(List<Enrollment>? enrollments) {
    if (enrollments!.length > 0) {
      final enrollment = enrollments[0];
      final enrollmentDate = enrollment.enrollmentDate.toString();
      DateTime sanitizedDate = DateTime.parse(enrollmentDate);
      return '${sanitizedDate.year.toString()}-${sanitizedDate.month.toString().padLeft(2, '0')}-${sanitizedDate.day.toString().padLeft(2, '0')}';
    } else {
      return '';
    }
  }

  sanitizedEnrollmentStatus(List<Enrollment>? enrollments) {
    if (enrollments!.length > 0) {
      final enrollment = enrollments[0];
      final status = enrollment.status.toString();
      return status == "ACTIVE"? "INCOMPLETE": status;
    } else {
      return '';
    }
  }

  getAttributeValue(attribute, String attributeId) {
    List<TrackedEntityAttributeValue> caseIdAttribute = attribute
        .where((TrackedEntityAttributeValue attribute) =>
            attribute.attribute == attributeId)
        .toList();
    return caseIdAttribute.length > 0 ? caseIdAttribute[0].value : '-';
  }

  getProgramAttributes() async {
    final List<ProgramTrackedEntityAttribute> programAttributes =
        await ProgramTrackedEntityAttributeQuery()
            .where(attribute: "program", value: widget.programId)
            .withOptions()
            .get();
    setState(() {
      programAttributesMetadata = programAttributes;
    });
  }

  renderCaseDetails() {

    List<CaseListingParams> caseListingParams = caseListingParamsFromJson(
        json.encode(widget.caseListingAttributeParams));
    return caseListingParams
        .map<Widget>((i) => Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(i.label,
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          decoration: TextDecoration.none)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      getAttributeValue(widget.trackedEntityInstance.attributes,
                          i.id.toString()), // caseID
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none)),
                )
              ],
            ))
        .toList();
    // return caseDetails;
  }

  Future<TrackedEntityInstance> synchroniseTrackedEntityInstanceData(
      TrackedEntityInstance trackedEntityInstance) async {
    // print("nnaiteaw");
    final tei = widget.trackedEntityInstance;
    final caseId = getAttributeValue(
        tei.attributes, widget.caseListingAttributeParams?[0]?['id']);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Synchronizing Case ID $caseId'),
      backgroundColor: AppColors.bgPrimary,
    ));
    try {
      List<TrackedEntityInstance> teiSynchronizationResponse = await D2Touch
          .trackerModule.trackedEntityInstance
          .byId(trackedEntityInstance.id as String)
          .upload((p0, p1) {

      });


      if(teiSynchronizationResponse.length > 0){

        // print("opt 1");

        widget.trackedEntityInstance.synced = teiSynchronizationResponse[0].synced;
        widget.trackedEntityInstance.syncFailed = teiSynchronizationResponse[0].syncFailed;
        widget.trackedEntityInstance.lastSyncDate = teiSynchronizationResponse[0].lastSyncSummary;
        widget.trackedEntityInstance.lastUpdated = teiSynchronizationResponse[0].lastUpdated;
        
        if(widget.trackedEntityInstance.syncFailed == false && widget.trackedEntityInstance.synced == true){

          // print("opt 2");

          // succesfull
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Case ID $caseId Sync Successful'),
            backgroundColor: AppColors.textSuccess,
          ));
          
        }else{

          // print("opt 3");
          // failed
          // print(teiSynchronizationResponse[0].syncFailed);
          // print(teiSynchronizationResponse[0].lastSyncSummary);
          // print(teiSynchronizationResponse[0].synced);
          showErrorOnBottomSheet(widget.trackedEntityInstance);
          
        }

      }else{

        // print("opt 4");
        widget.trackedEntityInstance.synced = false;
        widget.trackedEntityInstance.syncFailed = true;
        //failed

        showErrorOnBottomSheet(widget.trackedEntityInstance);

      }


      
    } catch (e) {

      // String errorMessage = e.toString();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Sync failed, Error: $errorMessage'),
      //   backgroundColor: AppColors.textDanger,
      // ));
      // print("this way");
      // print(e);

      showErrorOnBottomSheet(widget.trackedEntityInstance);
    }

    setState(() {
      synchronizing = false;
    });

    return trackedEntityInstance;
  }

  getSnackBarMessage() {
    final tei = widget.trackedEntityInstance;
    final caseId = getAttributeValue(
        tei.attributes, widget.caseListingAttributeParams?[0]?['id']);
    // return 'Synchronizing Case ID $caseId saved successfully';
    return 'Synchronizing Case ID $caseId...';
  }


  void showErrorOnBottomSheet(TrackedEntityInstance trackedEntityInstance) {
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
                                  (trackedEntityInstance.lastSyncSummary != null && trackedEntityInstance.lastSyncSummary != "" ? trackedEntityInstance.lastSyncSummary as String: ""),
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
