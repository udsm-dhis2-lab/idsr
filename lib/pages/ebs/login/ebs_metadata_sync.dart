import 'dart:async';

import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/metadata/program/queries/program.query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EbsMetadataSyncWidget extends StatefulWidget {
  const EbsMetadataSyncWidget({Key? key}) : super(key: key);

  @override
  _EbsMetadataSyncWidgetState createState() => _EbsMetadataSyncWidgetState();
}

class _EbsMetadataSyncWidgetState extends State<EbsMetadataSyncWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String currentProcess = "";
  String currentSubProcess = "";
  double processPercent = 0;
  bool processesRunning = false;
  int numberOfProcesses = 5;
  double progresIndicatorFractions = 0.0;
  List<String> succesfullProcesses = [];

  downloadMetaData() async {
    setState(() {
      processesRunning = true;
      // processPercent = 1.0;
    });

    setState(() {
      currentProcess = "Syncing organisation units";
    });

    try {
      var orgUnitSyncResponse = await D2Touch
          .organisationUnitModule.organisationUnit
          .download((p0, p1) {
        setState(() {
          processPercent = p0.percentage / 600;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    setState(() {
      currentProcess = "Syncing datasets";
      succesfullProcesses.add("Organisation units synced");
    });

    try {
      var dataSetsSyncResponse = await D2Touch.dataSetModule.dataSet
          .byId("NDcgQeGaJC9")
          .download((p0, p1) {
        setState(() {
          processPercent = (p0.percentage + 100) / 600;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    setState(() {
      currentProcess = "Syncing program configurations";
      succesfullProcesses.add("Datasets synced");
    });

    try {
      var programSyncResponse = await ProgramQuery().byIds(
        // ["ib6PYHQ5Aa8", "bWW1WxiP9lY", "A3olldDSHQg"]
          ["bWW1WxiP9lY"]).download((p0, p1) {
        setState(() {
          processPercent = (p0.percentage + 200) / 600;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    setState(() {
      currentProcess = "Syncing Attribute Reserved Values";
      succesfullProcesses.add("Program configurations synced");
    });

    try {
      var reserveValueSync =
      await D2Touch.trackerModule.attributeReservedValue.download((p0, p1) {
        // print(p0.percentage);
        // print(p0.message);
        setState(() {
          processPercent = (p0.percentage + 300) / 600;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {
      // print("error on syncing reserved vals");
      // print(error.toString());
    }

    setState(() {
      currentProcess = "Syncing Program Rules";
      succesfullProcesses.add("Reserved Values synced");
    });

    try {
      var rulesSync = await D2Touch.programModule.programRule
          .whereIn(
          attribute: "program",
          // values: ["ib6PYHQ5Aa8", "bWW1WxiP9lY", "A3olldDSHQg"],
          values: ["bWW1WxiP9lY"],
          merge: false)
          .download((p0, p1) {
        setState(() {
          processPercent = (p0.percentage + 400) / 600;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    setState(() {
      currentProcess = "Syncing Validation Rules";
      succesfullProcesses.add("Program Rules synced");
    });

    try {
      var validationRulesSync = await D2Touch.dataSetModule.validationRule
          .where(attribute: "dataSet", value: "NDcgQeGaJC9")
          .download((p0, p1) {
        print("validation rules downloads");
        print(p0.percentage);
        print(p0.message);

        setState(() {
          processPercent = (p0.percentage + 500) / 600;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    setState(() {
      succesfullProcesses.add("Validation Rules synced");
      currentProcess = "";
      processesRunning = false;
    });

    await updateMetadataSyncTime();

    Navigator.pop(context, true);
  }

  Future<void> updateMetadataSyncTime() async {
    DateTime syncCompletedAt = DateTime.now();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        "last_metadata_sync",
        syncCompletedAt.year.toString() +
            "-" +
            syncCompletedAt.month.toString() +
            "-" +
            syncCompletedAt.day.toString() +
            " " +
            syncCompletedAt.hour.toString() +
            ":" +
            syncCompletedAt.minute.toString());
  }

  @override
  void initState() {
    super.initState();

    downloadMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: processesRunning
                  ? [
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new CircularPercentIndicator(
                        animation: true,
                        radius: 80.0,
                        animateFromLastPercent: true,
                        lineWidth: 4.0,
                        animationDuration: 2000,
                        percent: processPercent,
                        center: Container(
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  RotationTransition(
                                      turns: _animation,
                                      child: Image.asset(
                                        'images/eIDSR.png',
                                        width: 50,
                                        height: 50,
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(top: 15),
                                      child: new Text(
                                        "${(processPercent * 100).round()}%",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      )),
                                ])),
                        progressColor:
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentSubProcess,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                                fontSize: 12.0),
                          )
                        ]))
              ]
                  : [],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
