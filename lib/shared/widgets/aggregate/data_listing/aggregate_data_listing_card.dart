import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/aggregate/entities/data_value.entity.dart';
import 'package:dhis2_flutter_sdk/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/weekly/weekly_dataentry.dart';
import 'package:eIDSR/shared/model/custom_dataelement_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AggregateDataListing extends StatefulWidget {
  DataValueSet dataValueSet;
  String datasetId;
  List<CustomDataElement> datasetDataElements;
  OrganisationUnit selectedOrgUnit;
  final String period;
  final DateTime periodStartDate;
  final DateTime periodEndDate;

  AggregateDataListing(
      {Key? key,
      required this.dataValueSet,
      required this.datasetId,
      required this.datasetDataElements,
      required this.selectedOrgUnit,
      required this.periodEndDate,
      required this.periodStartDate,
      required this.period})
      : super(key: key);

  @override
  State<AggregateDataListing> createState() => _AggregateDataListingState();
}

class _AggregateDataListingState extends State<AggregateDataListing>
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
  void initState() {
    super.initState();
    // // print(widget.dataValueSet.dataValues![0].toJson());
  }

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
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "WEEK " +
                              widget.period.split("W")[1] +
                              " : " +
                              sanitizedDateFormat(
                                  widget.periodStartDate.toIso8601String()) +
                              " - " +
                              sanitizedDateFormat(
                                  widget.periodEndDate.toIso8601String()),
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.none)),
                    ],
                  ),
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
                                      Icons.sync_rounded,
                                      color: Colors.blueAccent,
                                    ),
                                    tooltip: 'Sync',
                                    onPressed: () {
                                      setState(() {
                                        synchronizing = true;
                                      });

                                      synchronizeDataSet();
                                    }))
                            : IconButton(
                                icon: Icon(
                                  widget.dataValueSet.synced == false &&
                                          widget.dataValueSet.syncFailed != true
                                      ? Icons.sync_rounded
                                      : widget.dataValueSet.syncFailed == true
                                          ? Icons.sync_problem
                                          : widget.dataValueSet.synced == true
                                              ? Icons.check_circle_outline
                                              : Icons.sync_problem,
                                  color: widget.dataValueSet.synced == false &&
                                          widget.dataValueSet.syncFailed != true
                                      ? Colors.blueAccent
                                      : widget.dataValueSet.syncFailed == true
                                          ? AppColors.textDanger
                                          : widget.dataValueSet.synced == true
                                              ? AppColors.textSuccess
                                              : AppColors.textMuted,
                                ),
                                tooltip: 'Sync',
                                onPressed: () {
                                  setState(() {
                                    synchronizing = true;
                                  });

                                  synchronizeDataSet();
                                }),
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('Filled Data Items',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.none)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                            getPercentageOfFilledDataItems(
                                    widget.dataValueSet) +
                                "%",
                            // caseID
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('Completion Date',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.none)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                            widget.dataValueSet.completeDate == null
                                ? "-"
                                : widget.dataValueSet.completeDate
                                    ?.split("T")[0] as String,
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Divider(),
            Container(
              padding: EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.dataValueSet.completeDate != null
                          ? 'COMPLETED'
                          : 'INCOMPLETE',
                      style: TextStyle(
                          fontSize: 14,
                          color: widget.dataValueSet.completeDate != null
                              ? AppColors.textSuccess
                              : AppColors.textMuted,
                          decoration: TextDecoration.none)),
                  Row(
                    children: [
                      /*TextButton(
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        onPressed: () {
                          // TODO: revert orgunit
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => WeeklyDataEntry(
                          //           selectedOrgUnit: ,
                          //             datasetId: '',
                          //             datasetDataElement: [],
                          //             dataValueSet: widget.dataValueSet,
                          //           )),
                          // );
                        },
                     View ),*/
                      TextButton(
                        child: Text(
                          'Update Data',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        onPressed: () {
                          // TODO: revert orgunit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeeklyDataEntry(
                                      selectedOrgUnit: widget.selectedOrgUnit,
                                      datasetId: '',
                                      datasetDataElement: [],
                                      dataValueSet: widget.dataValueSet,
                                    )),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getPercentageOfFilledDataItems(DataValueSet dataValueSet) {
    List<DataValue> dataValues = dataValueSet.dataValues
        ?.where((element) => element.value != null && element.value != "")
        .toList() as List<DataValue>;

    // TODO: softcode the total number of data items

    return ((dataValues.length / 41) * 100).toString().split(".")[0];
  }

  Future<void> synchronizeDataSet() async {
    List<DataValueSet> dataValuesSendingResponse = [];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Synchronizing report'),
      backgroundColor: AppColors.bgPrimary,
    ));
    try {
      dataValuesSendingResponse = await D2Touch.aggregateModule.dataValueSet
          .byId(widget.dataValueSet.id as String)
          .upload((p1, p0) {
        // print(p0);
        // print(p1);
      });

      if (dataValuesSendingResponse[0].syncFailed == true) {
        widget.dataValueSet.lastSyncSummary =
            dataValuesSendingResponse[0].lastSyncSummary;
        widget.dataValueSet.synced = dataValuesSendingResponse[0].synced;
        widget.dataValueSet.lastSyncDate =
            dataValuesSendingResponse[0].lastSyncDate;
        widget.dataValueSet.syncFailed =
            dataValuesSendingResponse[0].syncFailed;

        showErrorOnBottomSheet(dataValuesSendingResponse[0]);
      } else {
        widget.dataValueSet.lastSyncSummary =
            dataValuesSendingResponse[0].lastSyncSummary;
        widget.dataValueSet.synced = dataValuesSendingResponse[0].synced;
        widget.dataValueSet.lastSyncDate =
            dataValuesSendingResponse[0].lastSyncDate;
        widget.dataValueSet.syncFailed =
            dataValuesSendingResponse[0].syncFailed;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Synchronization Succesful'),
          backgroundColor: AppColors.textSuccess,
        ));
      }
    } catch (e) {
      // print(e);
      // widget.dataValueSet.lastSyncSummary = dataValuesSendingResponse[0].lastSyncSummary;
      // widget.dataValueSet.synced = dataValuesSendingResponse[0].synced;
      // widget.dataValueSet.lastSyncDate = dataValuesSendingResponse[0].lastSyncDate;
      widget.dataValueSet.synced = false;
      widget.dataValueSet.syncFailed = true;

      showErrorOnBottomSheet(widget.dataValueSet);
      //
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Synchronization Failed'),
      //   backgroundColor: AppColors.textDanger,
      // ));
    }
    // // print("9999999999999999999999999999999999999999999999");
    // print(dataValuesSendingResponse[0].lastSyncSummary);

    setState(() {
      synchronizing = false;
    });
  }

  sanitizedDateFormat(String dateString) {
    DateTime sanitizedDate = DateTime.parse(dateString);

    return '${sanitizedDate.year.toString()}/${sanitizedDate.month.toString().padLeft(2, '0')}/${sanitizedDate.day.toString().padLeft(2, '0')}';
  }

  void showErrorOnBottomSheet(DataValueSet dataValueSet) {
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
                              (dataValueSet.lastSyncSummary != null &&
                                      dataValueSet.lastSyncSummary != ""
                                  ? dataValueSet.lastSyncSummary as String
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
