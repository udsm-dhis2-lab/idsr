import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/queries/program.query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetadataDownload extends StatefulWidget {
  final VoidCallback onSyncComplete;
  final String intervention;

  const MetadataDownload(
      {Key? key, required this.onSyncComplete, required this.intervention})
      : super(key: key);

  @override
  _MetadataDownloadState createState() => _MetadataDownloadState();
}

class _MetadataDownloadState extends State<MetadataDownload> {
  String currentProcess = "";
  String currentSubProcess = "";
  double processPercent = 0;
  bool processesRunning = false;
  int numberOfProcesses = 6;
  double progresIndicatorFractions = 0.0;
  List<String> succesfullProcesses = [];
  String dataLastSync = "";

  downloadIbsMetaData() async {
    setState(() {
      processesRunning = true;
      processPercent = 1.0;
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
      var dataSetsSyncResponse =
          await D2Touch.dataSetModule.dataSet.download((p0, p1) {
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
      var programStagesSyncResponse = await ProgramQuery().byIds(
          ["ib6PYHQ5Aa8", "bWW1WxiP9lY", "A3olldDSHQg"]).download((p0, p1) {
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
              values: ["ib6PYHQ5Aa8", "bWW1WxiP9lY", "A3olldDSHQg"],
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
      var validationRulesSync =
          await D2Touch.dataSetModule.validationRule.download((p0, p1) {
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

    this.widget.onSyncComplete();

    // Navigator.pop(context, true);
  }

  downloadMcbsMetaData() async {
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
          processPercent = p0.percentage / 400;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    setState(() {
      currentProcess = "Syncing program configurations";
      succesfullProcesses.add("Organisation units synced");
    });
    //
    // try {
    //   var dataSetsSyncResponse = await D2Touch.dataSetModule.dataSet
    //       .byId("NDcgQeGaJC9")
    //       .download((p0, p1) {
    //     setState(() {
    //       processPercent = (p0.percentage + 100) / 600;
    //       currentSubProcess = p0.message;
    //     });
    //   });
    // } catch (error) {}

    // setState(() {
    //   currentProcess = "Syncing program configurations";
    //   succesfullProcesses.add("Datasets synced");
    // });

    try {
      var programSyncResponse =
          await ProgramQuery().byIds(["ib6PYHQ5Aa8", "A3olldDSHQg"]
              //   ["bWW1WxiP9lY"]
              ).download((p0, p1) {
        setState(() {
          processPercent = (p0.percentage + 100) / 400;
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
          processPercent = (p0.percentage + 200) / 400;
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
              values: ["ib6PYHQ5Aa8", "A3olldDSHQg"],
              // values: ["bWW1WxiP9lY"],
              merge: false)
          .download((p0, p1) {
        setState(() {
          processPercent = (p0.percentage + 300) / 400;
          currentSubProcess = p0.message;
        });
      });
    } catch (error) {}

    // setState(() {
    //   currentProcess = "Syncing Validation Rules";
    //   succesfullProcesses.add("Program Rules synced");
    // });
    //
    // try {
    //   var validationRulesSync = await D2Touch.dataSetModule.validationRule
    //       .where(attribute: "dataSet", value: "NDcgQeGaJC9")
    //       .download((p0, p1) {
    //     print("validation rules downloads");
    //     print(p0.percentage);
    //     print(p0.message);
    //
    //     setState(() {
    //       processPercent = (p0.percentage + 500) / 600;
    //       currentSubProcess = p0.message;
    //     });
    //   });
    // } catch (error) {}

    setState(() {
      succesfullProcesses.add("Program Rules synced");
      currentProcess = "";
      processesRunning = false;
    });

    await updateMetadataSyncTime();

    widget.onSyncComplete();
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

  Future<String> getLastMetadataSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lastSyncTime = await prefs.getString("last_metadata_sync");

    if (lastSyncTime == null) {
      return "";
    } else {
      return (lastSyncTime as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: processesRunning ? [Text('$currentProcess')] : [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: processesRunning
                ? [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: new CircularPercentIndicator(
                        animation: true,
                        radius: 60.0,
                        lineWidth: 5.0,
                        animateFromLastPercent: true,
                        animationDuration: 2000,
                        percent: processPercent,
                        center: new Text(
                          "${(processPercent * 100).round()}%",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        progressColor: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ]
                : [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: processesRunning
                ? [
                    // CircularProgressIndicator(
                    //   value: currentProcessProgress.toDouble(),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        child: Text(
                          '${currentSubProcess}',
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    )
                  ]
                : [],
          ),
          processesRunning
              ? SizedBox(
                  height: 20,
                )
              : SizedBox(
                  height: 0,
                ),
          TextButton(
              onPressed: processesRunning
                  ? null
                  : widget.intervention == 'ibs'
                      ? () {
                          downloadIbsMetaData();
                        }
                      : widget.intervention == 'mcbs'
                          ? () {
                              downloadMcbsMetaData();
                            }
                          : () {},
              style: ButtonStyle(
                backgroundColor: processesRunning
                    ? MaterialStateProperty.all<Color>(Colors.black12)
                    : MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          processesRunning
                              ? "DOWNLOADING METADATA"
                              : "DOWNLOAD METADATA",
                          style: TextStyle(
                              color: processesRunning
                                  ? Colors.black12
                                  : Theme.of(context).colorScheme.onPrimary),
                        )
                      ]))),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
