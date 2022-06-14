import 'dart:convert';

import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/attribute_reserved_value.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/enrollment.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/tracker/entities/tracked_entity_attribute_value.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/queries/program_tracked_entity_attribute.query.dart';
import 'package:dhis2_flutter_sdk/shared/utilities/sort_order.util.dart';
import 'package:eIDSR/shared/widgets/tracker/data_entry/tracker_dataentry_form.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/widgets/tracker/case_listing/tracker_case_listing_card.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

class TrackerProgramPage extends StatefulWidget {
  String programId;
  String? title;
  final bool disableCompleting;
  final trackerformSection;
  final caseListingAttributeParams;
  final bool hideEditButton;
  final bool hideViewButton;
  final bool editStagesOnly;
  final bool hideAddTrackerButton;
  final bool hideEnrollmentActiveness;

  TrackerProgramPage(
      {Key? key,
      required this.programId,
      this.trackerformSection: const [],
      required this.caseListingAttributeParams,
      this.hideEditButton: false,
      this.hideViewButton: false,
      this.hideAddTrackerButton: false,
      this.editStagesOnly: false,
      required this.disableCompleting,
      this.hideEnrollmentActiveness: false,
      this.title})
      : super(key: key);

  @override
  _TrackerProgramPageState createState() => _TrackerProgramPageState();
}

class _TrackerProgramPageState extends State<TrackerProgramPage>
    with TickerProviderStateMixin {
  double topSelectionHeight = 60;
  bool trackerCaseLoading = false;
  late AnimationController circularController;
  List<Widget> trackedEntityInstances = [];
  List<ProgramTrackedEntityAttribute> programAttributesMetadata = [];
  OrganisationUnit? selectedOrgUnit;

  AppBar trackerAppBar = AppBar(
    title: Text('Report'),
  );

  @override
  void initState() {
    // print("on program page");
    // print(widget.disableCompleting);

    trackerAppBar = AppBar(
      title: Text('${widget.title == null ? 'Tracker' : widget.title} Report'),
    );
    circularController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        // setState(() {});
      });
    circularController.repeat(reverse: true);

    super.initState();
    // loadTrackerCases();
    getProgramAttributes();
  }

  @override
  void dispose() {
    circularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: trackerAppBar,
        floatingActionButton: widget.hideAddTrackerButton == true
            ? SizedBox(
                height: 0,
                width: 0,
              )
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: selectedOrgUnit == null
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackerDataEntryForm(
                                  disableCompleting: widget.disableCompleting,
                                  attributeParams:
                                      widget.caseListingAttributeParams,
                                  programId: widget.programId,
                                  selectedOrgUnit: selectedOrgUnit,
                                  trackerformSection: widget.trackerformSection,
                                  programAttributes:
                                      programAttributesMetadata)),
                        );
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
              child: Column(
                children: [
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton.icon(
                                        icon: Icon(Icons.account_tree_outlined),
                                        label: selectedOrgUnit == null
                                            ? Text(
                                                'Select Facility',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )
                                            : Text(
                                                '${selectedOrgUnit?.name}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                        onPressed: () {
                                          showActionsDialog(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: widget.hideAddTrackerButton == true
                                      ? Column(
                                          children: [],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            selectedOrgUnit == null
                                                ? TextButton.icon(
                                                    icon: Icon(
                                                      Icons.add_outlined,
                                                      color:
                                                          AppColors.textMuted,
                                                    ),
                                                    label: Text(
                                                      'New Case',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.textMuted,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    onPressed: null)
                                                : TextButton.icon(
                                                    icon: Icon(
                                                        Icons.add_outlined),
                                                    label: Text(
                                                      'New Case',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => TrackerDataEntryForm(
                                                                disableCompleting:
                                                                    widget
                                                                        .disableCompleting,
                                                                attributeParams:
                                                                    widget
                                                                        .caseListingAttributeParams,
                                                                programId: widget
                                                                    .programId,
                                                                selectedOrgUnit:
                                                                    selectedOrgUnit,
                                                                trackerformSection:
                                                                    widget
                                                                        .trackerformSection,
                                                                programAttributes:
                                                                    programAttributesMetadata)),
                                                      );
                                                    },
                                                  )
                                          ],
                                        ),
                                )
                              ],
                            ),
                          ),
                          selectedOrgUnit != null
                              ? FutureBuilder(
                                  future: newLoadTrackerCases(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return Container(
                                          child: Column(
                                        children: [
                                          ...(snapshot.data
                                              as List<TrackerCaseListing>)
                                        ],
                                      ));
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
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 20),
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
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Loading Cases...',
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
                                  })
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          left: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 2))),
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.15,
                                      left: 30,
                                      right: 30),
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Center(
                                    heightFactor: 1,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("No Facility Selected"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Select Facility to continue"),
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
                                                    .onPrimary),
                                            icon: Icon(
                                                Icons.account_tree_outlined),
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
                                ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ));
  }

  Future<List<TrackerCaseListing>> newLoadTrackerCases() async {
    // print("step 1");

    List<TrackedEntityInstance> trackedEntityInstancesData = await D2Touch
        .trackerModule.trackedEntityInstance
        .withAttributes()
        .withEnrollments()
        .byProgram(widget.programId)
        .byOrgUnit('${selectedOrgUnit?.id}')
        .get();

    // print("step 2");

    if (trackedEntityInstancesData.length == 0) {
      await D2Touch.trackerModule.trackedEntityInstance
          .byProgram(widget.programId)
          .byOrgUnit('${selectedOrgUnit?.id}')
          .download((progress, completed) => {});
    }

    // print("step 3");

    // Finally fetch again updated cases from SDK
    trackedEntityInstancesData = await D2Touch
        .trackerModule.trackedEntityInstance
        .withAttributes()
        .withEnrollments()
        .byProgram(widget.programId)
        .byOrgUnit('${selectedOrgUnit?.id}')
        .orderBy(attribute: 'lastUpdated', order: SortOrder.ASC)
        .get();

    trackedEntityInstancesData.sort( (TrackedEntityInstance a, TrackedEntityInstance b){

      return sanitizedDateFormat(b.enrollments).compareTo(sanitizedDateFormat(a.enrollments));
    });

    List<TrackerCaseListing> trackerCaseListings =
        trackedEntityInstancesData.map((TrackedEntityInstance trackerCase) {
      return TrackerCaseListing(
        trackerformSection: widget.trackerformSection,
        trackedEntityInstance: trackerCase,
        programId: widget.programId,
        disableCompleting: widget.disableCompleting,
        caseListingAttributeParams: widget.caseListingAttributeParams,
        hideEditButton: widget.hideEditButton,
        hideViewButton: widget.hideViewButton,
        editStagesOnly: widget.editStagesOnly,
        hideEnrollmentActiveness: widget.hideEnrollmentActiveness,
      );
    }).toList();

    return trackerCaseListings;
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

  Future<void> showActionsDialog(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );

    setState(() {
      selectedOrgUnit = result[0];
    });
  }

  dialogOptionAction(String action, BuildContext context) {}

  orgunitSelectionView() {
    return selectedOrgUnit?.id == null
        ? Container(
            height: MediaQuery.of(context).size.height -
                (trackerAppBar.preferredSize.height +
                    topSelectionHeight +
                    MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).padding.bottom),
            child: Center(
              heightFactor: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No Facility Selected"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Select Facility to continue"),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          primary: Theme.of(context).colorScheme.onPrimary),
                      icon: Icon(Icons.account_tree_outlined),
                      label: selectedOrgUnit == null
                          ? Text("Select Facility")
                          : Text(
                              '${selectedOrgUnit?.name}',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                      onPressed: () {
                        navigateToOrgUnitSelector(context);
                      },
                    ),
                  ]),
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  showCaseLoadingAnimation() {
    return trackerCaseLoading
        ? Container(
            height: MediaQuery.of(context).size.height -
                (trackerAppBar.preferredSize.height +
                    topSelectionHeight +
                    MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).padding.bottom),
            // (trackerAppBar.preferredSize.height + 92),
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        value: circularController.value,
                      ),
                      Text('Loading cases...')
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox(height: 0);
  }

  showCaseListing() {
    return selectedOrgUnit != null && trackerCaseLoading == false
        ? Container(
            height: MediaQuery.of(context).size.height -
                (trackerAppBar.preferredSize.height +
                    topSelectionHeight +
                    MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).padding.bottom),
            child: trackerCaseLoading
                ? SizedBox(height: 0)
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: trackedEntityInstances.length,
                    itemBuilder: (BuildContext context, int index) {
                      return trackedEntityInstances[index];
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
          )
        : SizedBox(
            height: 0,
          );
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

  String sanitizedDateFormat(List<Enrollment>? enrollments) {
    if (enrollments!.length > 0) {
      final enrollment = enrollments[0];
      final enrollmentDate = enrollment.enrollmentDate.toString();
      DateTime sanitizedDate = DateTime.parse(enrollmentDate);
      return '${sanitizedDate.year.toString()}-${sanitizedDate.month.toString().padLeft(2, '0')}-${sanitizedDate.day.toString().padLeft(2, '0')}';
    } else {
      return '';
    }
  }
}
