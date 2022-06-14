import 'dart:convert';
import 'package:week_of_year/week_of_year.dart';
import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/auth/user/entities/user.entity.dart';
import 'package:d2_touch/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/shared/model/custom_dataelement_model.dart';
import 'package:eIDSR/shared/widgets/aggregate/data_listing/aggregate_data_listing_card.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/weekly/widgets/new_report_list_card.dart';
import 'package:eIDSR/shared/widgets/card_widgets/user_welcome_widget.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

class WeeklyPage extends StatefulWidget {
  WeeklyPage({Key? key}) : super(key: key);

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends State<WeeklyPage> with TickerProviderStateMixin {
  late AnimationController circularController;
  bool aggregateCaseLoading = false;
  User? currentUser;
  OrganisationUnit? selectedOrgUnit;
  List<Widget> aggregateDataList = [];
  List<CustomDataElement> datasetDataElement = [];

  AppBar aggregateAppBar = AppBar(
    title: Text('Weekly Report'),
  );

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

    getCurrentUserInfo();
    getAggregateMetadata();
    // loadAggregateCases();
  }

  @override
  void dispose() {
    circularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: aggregateAppBar,
      body: ListView(
        children: [
          Container(
            width: double.maxFinite,
            // height: double.maxFinite,
            color: AppColors.whiteSmoke,
            child: Column(
              children: [
                Container(
                  // height: 60,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 10),
                  child: Container(
                    width: (MediaQuery.of(context).size.width * 1) - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.account_tree_outlined),
                          label: selectedOrgUnit == null
                              ? Text(
                                  'Select Facility',
                                  style: TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis),
                                )
                              : Text(
                                  '${selectedOrgUnit?.name}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis),
                                ),
                          onPressed: () {
                            navigateToOrgUnitSelector(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                selectedOrgUnit == null
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                left: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2))),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.15,
                            left: 30,
                            right: 30),
                        padding: EdgeInsets.only(top: 20, bottom: 20),
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
                                      primary: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
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
                    : FutureBuilder(
                        future: getAggregateDataList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            List<WeeklyReportState> weeksNotReported =
                                (snapshot.data as List<WeeklyReportState>)
                                    .where((WeeklyReportState reportState) {
                              return reportState.dataValueSet == null
                                  ? true
                                  : false;
                            }).toList();

                            return Container(
                              // decoration:
                              //     BoxDecoration(color: AppColors.textDanger),
                              padding: EdgeInsets.only(
                                  top: 0, left: 0, right: 0, bottom: 0),

                              child: Column(children: [
                                UserWelcomeCard(
                                  header: 'Welcome ${currentUser?.name ?? ''}',
                                  description:
                                      'This is week ${DateTime.now().weekOfYear} ${weeksNotReported.length > 0 ? "and it looks like you have not reported for weeks " + getWeeksNotReported(snapshot.data as List<WeeklyReportState>) + " yet" : ", congratulations for submitting all reports"}. Timely report insures you correctness of data and timely submission.',
                                ),
                                ...(snapshot.data as List<WeeklyReportState>)
                                    .map((WeeklyReportState weekReport) {
                                  return weekReport.dataValueSet == null
                                      ? NewReportListing(
                                          selectedOrganisationUnit:
                                              selectedOrgUnit
                                                  as OrganisationUnit,
                                          period: weekReport.period,
                                          datasetId:
                                              AppConstants.weeklyDatasetUid,
                                          datasetDataElements:
                                              datasetDataElement,
                                          periodEndDate: weekReport.weekEndDate,
                                          periodStartDate:
                                              weekReport.weekStartDate,
                                        )
                                      : AggregateDataListing(
                                          selectedOrgUnit: selectedOrgUnit
                                              as OrganisationUnit,
                                          dataValueSet: weekReport.dataValueSet
                                              as DataValueSet,
                                          datasetId:
                                              AppConstants.weeklyDatasetUid,
                                          datasetDataElements:
                                              datasetDataElement,
                                          period: weekReport.period,
                                          periodEndDate: weekReport.weekEndDate,
                                          periodStartDate:
                                              weekReport.weekStartDate,
                                        );
                                }).toList()
                                /* NewReportListing(
                                        selectedOrganisationUnit:
                                        selectedOrgUnit as OrganisationUnit,
                                        period: "2022W06",
                                        datasetId: AppConstants.weeklyDatasetUid,
                                        datasetDataElements: datasetDataElement),
                                    ...aggregateDataList, */
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
                                  top:
                                      MediaQuery.of(context).size.height * 0.15,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            // valueColor: Colors.blue,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Loading Reports...',
                                            style: TextStyle(
                                                color: AppColors.textPrimary),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  String getWeeksNotReported(List<WeeklyReportState> weeklyReports) {
    return weeklyReports.where((WeeklyReportState report) {
      return report.dataValueSet == null;
    }).map((WeeklyReportState weekWithNoReport) {
      int weekNumber = int.parse(weekWithNoReport.period.split("W")[1]);

      return weekNumber;
    }).join(" ,");
  }

  Future<void> navigateToOrgUnitSelector(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );

    setState(() {
      selectedOrgUnit = result[0];
    });
    // load aggregate cases
    // loadAggregateCases();
  }

  Future<User?> getCurrentUserInfo() async {
    User? userInfo = await D2Touch.userModule.user.getOne();

    // return userInfo;
    setState(() {
      currentUser = userInfo!;
    });
  }

  getAggregateMetadata() async {
    List<CustomDataElement> customDataElement = customDataElementFromJson(
        json.encode(AppConstants.dataSetDataElements));
    setState(() {
      datasetDataElement = customDataElement;
    });
  }

  showCaseLoadingAnimation() {
    return aggregateCaseLoading
        ? Container(
            height: MediaQuery.of(context).size.height -
                (aggregateAppBar.preferredSize.height + 92),
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

  orgunitSelectionView() {
    return selectedOrgUnit?.id == null
        ? Container(
            height: MediaQuery.of(context).size.height -
                (aggregateAppBar.preferredSize.height + 92),
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

  Future<List<WeeklyReportState>> getAggregateDataList() async {
    List<WeeklyPeriod> periods = [];
    DateTime currentdate = DateTime.now();

    List<int> periodIndexes = [1, 2, 3, 4, 5];

    for (int i in periodIndexes) {
      DateTime date = currentdate.subtract(Duration(hours: (24 * 7) * i));
      String period =
          '${date.year.toString()}W${date.weekOfYear <= 9 ? "0" + date.weekOfYear.toString() : date.weekOfYear.toString()}';
      DateTime weekStartDate = date.subtract(Duration(days: date.weekday - 1));
      DateTime weekEndDate =
          date.add(Duration(days: DateTime.daysPerWeek - date.weekday));

      periods.add(new WeeklyPeriod(
          period: period,
          weekEndDate: weekEndDate,
          weekStartDate: weekStartDate));
    }

    List<Future<WeeklyReportState>> dataValueSetFutures =
        periods.map((WeeklyPeriod period) {
      return getDataValueSet(
          period.period, period.weekStartDate, period.weekEndDate);
    }).toList();

    List<WeeklyReportState> listOfWeeklyReports = [];

    try {
      listOfWeeklyReports = await Future.wait(dataValueSetFutures);
      // print(listOfWeeklyReports);
    } catch (e) {
      // print(e);
    }

    return listOfWeeklyReports;
  }

  Future<WeeklyReportState> getDataValueSet(
      String period, DateTime startDateTime, DateTime endDateTime) async {
    List<DataValueSet> dataValueSets =
        await D2Touch.aggregateModule.dataValueSet
            .byDataSet(AppConstants.weeklyDatasetUid)
            // .byPeriod(period)
            .where(attribute: "period", value: period)
            .where(attribute: "orgUnit", value: selectedOrgUnit?.id)
            // .byOrgUnit('${selectedOrgUnit?.id}')
            .withDataValues()
            .get();

    if (dataValueSets.length > 0) {
      return new WeeklyReportState(
          period: period,
          weekEndDate: endDateTime,
          weekStartDate: startDateTime,
          dataValueSet: dataValueSets[0]);
    }

    // download aggregate data from server
    try {
      await D2Touch.aggregateModule.dataValueSet
          .byDataSet(AppConstants.weeklyDatasetUid)
          .byOrgUnit('${selectedOrgUnit?.id}')
          .byPeriod(period)
          .withDataValues()
          .download((progress, complete) => {});
    } catch (e) {}

    // fetch again aggregate data from SDK
    dataValueSets = await D2Touch.aggregateModule.dataValueSet
        .byDataSet(AppConstants.weeklyDatasetUid)
        // .byOrgUnit('${selectedOrgUnit?.id}')
        // .byPeriod(period)
        .where(attribute: "orgUnit", value: selectedOrgUnit?.id)
        .where(attribute: "period", value: period)
        .withDataValues()
        .get();

    return dataValueSets.length > 0
        ? new WeeklyReportState(
            period: period,
            weekEndDate: endDateTime,
            weekStartDate: startDateTime,
            dataValueSet: dataValueSets[0])
        : new WeeklyReportState(
            period: period,
            weekEndDate: endDateTime,
            weekStartDate: startDateTime,
            dataValueSet: null);
  }
}

class WeeklyReportState {
  String period;
  DateTime weekStartDate;
  DateTime weekEndDate;
  DataValueSet? dataValueSet;

  WeeklyReportState(
      {required this.period,
      required this.weekEndDate,
      required this.weekStartDate,
      this.dataValueSet});
}

class WeeklyPeriod {
  String period;
  DateTime weekStartDate;
  DateTime weekEndDate;

  WeeklyPeriod(
      {required this.period,
      required this.weekEndDate,
      required this.weekStartDate});
}
