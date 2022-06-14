import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/pages/ibs/weekly/weekly_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/notification/widgets/notification-list-item.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_appbar_widget.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';
import 'package:week_of_year/date_week_extensions.dart';

class NotificationHome extends StatefulWidget {
  const NotificationHome({Key? key}) : super(key: key);

  @override
  _NotificationHomeState createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: AppColors.whiteSmoke,
      child: FutureBuilder(
        future: getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(children: [
              Column(children: [
                Container(
                  child: Column(
                      children: (snapshot.data as List).length == 0
                          ? [
                              Container(
                                child: Text("No new notifications"),
                              )
                            ]
                          : (snapshot.data as List).map((notification) {
                              return NotificationListItemWidget(
                                notificationMessage: notification["message"],
                                notificationRead: notification["read"],
                                notificationTime: notification["time"],
                                notificationType: notification["type"],
                                notificationTypeInitial:
                                    notification["initial"],
                              );
                            }).toList()
                      // notifications.map((notification) => {
                      //   return NotificationListItemWidget();
                      // }).toList();

                      ),
                )
              ])
            ]);
          } else {
            return ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: 30,
                      right: 30),
                  padding: EdgeInsets.only(
                      top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2))),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.black12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Loading Notifications...',
                        style: TextStyle(color: AppColors.textPrimary),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List> getNotifications() async {
    // calculate past 5 week periods
    await Future.delayed(Duration(seconds: 1));

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

    String? WeeksNotReported = listOfWeeklyReports
        .where((WeeklyReportState weeklyReportState) {
          return weeklyReportState.dataValueSet == null;
        })
        .map((WeeklyReportState report) {
          return report.period.split("W")[1];
        })
        .toList()
        .join(",");
    String WeeksReportedButNotCompleted = listOfWeeklyReports
        .where((WeeklyReportState weeklyReportState) {
          return weeklyReportState.dataValueSet != null &&
              (weeklyReportState.dataValueSet?.completeDate == null ||
                  weeklyReportState.dataValueSet?.completeDate == "");
        })
        .map((WeeklyReportState report) {
          return report.period.split("W")[1];
        })
        .toList()
        .join(",");
    String WeeksCompleted = listOfWeeklyReports
        .where((WeeklyReportState weeklyReportState) {
          return weeklyReportState.dataValueSet != null &&
              weeklyReportState.dataValueSet?.completeDate != null &&
              weeklyReportState.dataValueSet?.completeDate != "";
        })
        .map((WeeklyReportState report) {
          return report.period.split("W")[1];
        })
        .toList()
        .join(",");

    var notificationsList = [];

    if (WeeksCompleted != "") {
      notificationsList.add({
        "type": "WEEKLY REPORT NOTICE",
        "initial": "WR",
        "message": "Congratulations report(s) for week(s) " +
            WeeksCompleted +
            " have been completed",
        "time": "",
        "read": false
      });
    }

    if (WeeksReportedButNotCompleted != "") {
      notificationsList.add({
        "type": "WEEKLY REPORT NOTICE",
        "initial": "WR",
        "message": "Weekly reports for weeks " +
            WeeksReportedButNotCompleted +
            " have not been completed",
        "time": "",
        "read": false
      });
    }

    if (WeeksNotReported != "") {
      notificationsList.add({
        "type": "WEEKLY REPORT NOTICE",
        "initial": "WR",
        "message": "You have not reported for weeks " + WeeksNotReported,
        "time": "",
        "read": false
      });
    }

    return notificationsList;
  }

  Future<WeeklyReportState> getDataValueSet(
      String period, DateTime startDateTime, DateTime endDateTime) async {
    // print(period);

    List<DataValueSet> dataValueSets =
        await D2Touch.aggregateModule.dataValueSet
            .byDataSet(AppConstants.weeklyDatasetUid)
            .where(attribute: "period", value: period)
            // .byOrgUnit('GRDYT0QagNn')
            .withDataValues()
            .get();

    if (dataValueSets.length > 0) {
      return new WeeklyReportState(
          period: period,
          weekEndDate: endDateTime,
          weekStartDate: startDateTime,
          dataValueSet: dataValueSets[0]);
    }

    return new WeeklyReportState(
        period: period,
        weekEndDate: endDateTime,
        weekStartDate: startDateTime,
        dataValueSet: null);
  }
}
