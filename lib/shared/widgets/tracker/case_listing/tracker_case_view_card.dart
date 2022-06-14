import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/tracker/entities/enrollment.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/tracked_entity_attribute_value.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';
import 'package:d2_touch/modules/metadata/program/queries/program_tracked_entity_attribute.query.dart';
import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/modules/Events/pages/event_list.dart';
import 'package:eIDSR/shared/widgets/tracker/data_entry/tracker_dataentry_form.dart';
import 'package:flutter/material.dart';

class ViewTrackerCase extends StatefulWidget {
  TrackedEntityInstance trackedEntityInstance;
  String programId;
  OrganisationUnit? selectedOrgUnit;
  final bool disableCompleting;
  final trackerformSection;
  final caseListingAttributeParams;
  final bool editStagesOnly;
  List<ProgramTrackedEntityAttribute> programAttributes;

  ViewTrackerCase({
    Key? key,
    this.editStagesOnly: false,
    this.disableCompleting: false,
    required this.trackedEntityInstance,
    required this.trackerformSection,
    required this.programId,
    this.caseListingAttributeParams,
    required this.programAttributes,
  }) : super(key: key);

  @override
  State<ViewTrackerCase> createState() => _ViewTrackerCaseState();
}

class _ViewTrackerCaseState extends State<ViewTrackerCase> {
  double topSelectionHeight = 60;
  List<ProgramTrackedEntityAttribute> programAttributesMetadata = [];
  List<dynamic> expansionList = ['profileInfo'];
  bool profileInfoExpanded = false;
  AppBar trackerAppBar = AppBar(
    title: Text('Case View'),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: trackerAppBar,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: AppColors.whiteSmoke,
          child: Column(
            children: [
              Column(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: dataEntryOUtoDisplay(widget
                                            .trackedEntityInstance.enrollments),
                                        builder: (context, snapshot) => snapshot
                                                    .hasData &&
                                                snapshot.data != null
                                            ? TextButton.icon(
                                                icon: Icon(
                                                  Icons.account_tree_outlined,
                                                  color: AppColors.textMuted,
                                                ),
                                                label: Text(
                                                  (snapshot.data as String),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          AppColors.textMuted),
                                                ),
                                                onPressed: null,
                                              )
                                            : TextButton.icon(
                                                icon: Icon(
                                                  Icons.account_tree_outlined,
                                                  color: AppColors.textMuted,
                                                ),
                                                label: Text(
                                                  'Select Facility',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          AppColors.textMuted),
                                                ),
                                                onPressed: null,
                                              ))
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  widget.editStagesOnly == true
                                      ? SizedBox(
                                          height: 0,
                                          width: 0,
                                        )
                                      : TextButton.icon(
                                          icon: Icon(Icons.edit_outlined),
                                          label: Text(
                                            'Edit Case',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => TrackerDataEntryForm(
                                                      disableCompleting: widget
                                                          .disableCompleting,
                                                      attributeParams: widget
                                                          .caseListingAttributeParams,
                                                      programId:
                                                          widget.programId,
                                                      selectedOrgUnit: widget
                                                              .selectedOrgUnit
                                                          as OrganisationUnit,
                                                      trackerformSection: widget
                                                          .trackerformSection,
                                                      programAttributes: widget
                                                          .programAttributes)),
                                            );
                                          },
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15, left: 0, right: 0),
                          // 166 was the overflowing pixels
                          height: MediaQuery.of(context).size.height -
                              (trackerAppBar.preferredSize.height +
                                  topSelectionHeight +
                                  MediaQuery.of(context).padding.top +
                                  MediaQuery.of(context).padding.bottom),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            child: Container(
                              child: Column(children: [
                                caseSummaryCard(),
                                SizedBox(height: 10),
                                profileInfocExpansionList(),
                                SizedBox(height: 10),
                                widget.editStagesOnly == false
                                    ? SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                                    : Card(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: FutureBuilder(
                                            future: getProgramStageIds(
                                                widget.programId),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                return Column(
                                                  children: [
                                                    ...(snapshot.data
                                                            as List<String>)
                                                        .map((String
                                                            programStageId) {
                                                      return EventList(
                                                        // TODO:
                                                        eventProgramTitle:
                                                            "Re-ACD",
                                                        programId:
                                                            widget.programId,
                                                        stageUuid:
                                                            programStageId,
                                                        trackedEntityInstance:
                                                            widget
                                                                .trackedEntityInstance,
                                                        stageSummaryConfigurations:
                                                            AppConstants
                                                                    .eventSummaryListConfigs[
                                                                programStageId],
                                                        selectedOrgunit:
                                                            //TODO: org unit may be null, find a way to circumnavigate this
                                                            widget.selectedOrgUnit
                                                                as OrganisationUnit,
                                                        maxEventsOnList: 3,
                                                        showBottomAddButton:
                                                            true,
                                                        showStageTitle: true,
                                                      );
                                                    }).toList(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              completeEnrollment();
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary)),
                                                            child: Text(
                                                              "Complete",
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary),
                                                            ))
                                                      ],
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return Text("");
                                              }
                                            }))

                                // width: double.maxFinite,
                              ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Future<void> completeEnrollment() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Completing Case'),
      backgroundColor: AppColors.bgPrimary,
    ));
    //  update the tracked entity instance
    widget.trackedEntityInstance.enrollments?[0].status = "COMPLETED";

    // save locally
    await D2Touch.trackerModule.trackedEntityInstance
        .setData(widget.trackedEntityInstance)
        .save();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Case Completed'),
      backgroundColor: AppColors.bgPrimary,
    ));
  }

  Future<List<String>> getProgramStageIds(String programId) async {
    widget.selectedOrgUnit = await D2Touch
        .organisationUnitModule.organisationUnit
        .byId(widget.trackedEntityInstance.orgUnit)
        .getOne();

    List<ProgramStage> programStages = await D2Touch.programModule.programStage
        .where(attribute: "program", value: widget.programId)
        .get();

    if (programStages != null) {
      return programStages
          .map((ProgramStage programStage) => programStage.id as String)
          .toList();
    } else {
      return [];
    }
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

  caseSummaryCard() {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'Case Summary',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.blueThemeColor),
              ),
            ),
            SizedBox(height: 10),
            Container(
                child: FutureBuilder(
                    future: dataEntryOUtoDisplay(
                        widget.trackedEntityInstance.enrollments),
                    builder: (context, snapshot) =>
                        snapshot.hasData && snapshot.data != null
                            ? Text(
                                'Reported from ${snapshot.data}',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 11,
                                    color: AppColors.textMuted),
                              )
                            : Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.textMuted),
                              ))),
            Container(
              child: Text(
                  sanitizedDateFormat(widget.trackedEntityInstance.enrollments),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: AppColors.textMuted)),
            )
          ],
        ),
      ),
    );
  }

  profileInfocExpansionList() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              // expansionList[index].isExpanded = !isExpanded;
              profileInfoExpanded = !profileInfoExpanded;
            });
          },
          children: expansionList
              .map<ExpansionPanel>((item) => ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) =>
                        ListTile(
                            title: Text('Profile Info',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColors.blueThemeColor))),
                    body: Column(
                      children: renderProfileAttributeList(),
                    ),
                    isExpanded: profileInfoExpanded,
                  ))
              .toList()

          // [
          //   ExpansionPanel(
          //     headerBuilder: (BuildContext context, bool isExpanded) {
          //       return ListTile(
          //         title: Text('Item 1'),
          //       );
          //     },
          //     body: ListTile(
          //       title: Text('Item 1 child'),
          //       subtitle: Text('Details goes here'),
          //     ),
          //     isExpanded: true,
          //   ),
          //   ExpansionPanel(
          //     headerBuilder: (BuildContext context, bool isExpanded) {
          //       return ListTile(
          //         title: Text('Item 2'),
          //       );
          //     },
          //     body: ListTile(
          //       title: Text('Item 2 child'),
          //       subtitle: Text('Details goes here'),
          //     ),
          //     isExpanded: false,
          //   ),
          // ],
          ),
    );
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

  renderProfileAttributeList() {
    // List<ProgramTrackedEntityAttribute> sortedProgramAttributes =
    widget.programAttributes.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return widget.programAttributes
        .map(
          (i) => Column(
            children: [
              ListTile(
                title: Text(fetchAttributeName(i.attribute)),
                subtitle: Text(
                    getAttributeValue(
                        widget.trackedEntityInstance.attributes, i.attribute),
                    style: TextStyle(overflow: TextOverflow.ellipsis)),
              ),
              Divider()
            ],
          ),
        )
        .toList();
  }

  getAttributeValue(attribute, String attributeId) {
    List<TrackedEntityAttributeValue> caseIdAttribute = attribute
        .where((attributeItem) => attributeItem.attribute == attributeId)
        .toList();
    return caseIdAttribute.length > 0 ? caseIdAttribute[0].value : '';
  }

  fetchAttributeName(String attributeId) {
    List<ProgramTrackedEntityAttribute> programAttribute = widget
        .programAttributes
        .where((ProgramTrackedEntityAttribute attribute) =>
            attribute.attribute == attributeId)
        .toList();
    return programAttribute.length > 0 ? programAttribute[0].name : '-';
  }
}

class StageEvents {
  final String stageName;
  final List<Event> stageEvents;

  StageEvents({required this.stageEvents, required this.stageName});
}
