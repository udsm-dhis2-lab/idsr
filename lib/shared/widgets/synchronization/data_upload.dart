import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUpload extends StatefulWidget {
  const DataUpload({Key? key}) : super(key: key);

  @override
  _DataUploadState createState() => _DataUploadState();
}

class _DataUploadState extends State<DataUpload> {
  @override
  void initState() {
    super.initState();

    setExistingAutosyncConfigs();
  }

  TextEditingController intervalInputFieldController = TextEditingController();
  bool uploadingData = false;
  String currentProcess = "";
  double processPercent = 0;
  dynamic dataUploadSummary = {};
  bool? autoUploadOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            child: uploadingData == true
                ? SizedBox(
                    height: 0,
                  )
                : TextFormField(
                    onChanged: (String value) {
                      setAutomaticDataUploadInterval(value);
                    },
                    controller: intervalInputFieldController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Data upload interval (Minutes)',
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: uploadingData == true
                ? []
                : [
                    Text("Automatic data upload"),
                    Switch(
                        value:
                            autoUploadOn == null ? false : autoUploadOn as bool,
                        onChanged: (boolValue) {
                          setAutomaticDataUpload(boolValue);
                        })
                  ],
          ),
          SizedBox(
            height: uploadingData == true ? 0 : 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: uploadingData == true ? [] : [Text("Import Results")]),
          SizedBox(
            height: uploadingData == true ? 0 : 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: uploadingData
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]
                : [],
          ),
          uploadingData == true?  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: Text(
                '${currentProcess}',
                overflow: TextOverflow.fade,
              ),
            ),
          ]): SizedBox(height: 0, width: 0,),
          TextButton(
              onPressed: () {
                uploadData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "UPLOAD DATA NOW",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        )
                      ]))),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> setAutomaticDataUpload(bool automaticUploadOn) async {
    setState(() {
      autoUploadOn = automaticUploadOn;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("data_upload_auto", automaticUploadOn);
  }

  Future<void> setAutomaticDataUploadInterval(String interval) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("data_upload_interval", int.parse(interval));
  }

  Future<void> uploadData() async {
    // print("nnaitwa?");

    setState(() {
      uploadingData = true;
      currentProcess = "Initializing upload";
    });

    // print("step 1");

    //upload data sets
    try {
      // print("step 2");
      await D2Touch.aggregateModule.dataValueSet.upload((p0, p1) {
        // print(p0.percentage);
        // print(p0.message);
        setState(() {
          processPercent = p0.percentage / 300;
          currentProcess = p0.message;
        });
      });
    } catch (e) {
      // print("***** error 1");
      // print(e.toString());
      // print("step 3");
    }

    // print("step 4");
    // upload tracked entity instances
    try {
      // print("step 5");
      await D2Touch.trackerModule.trackedEntityInstance
          // .where(attribute: "synced", value: false)
          .upload((p0, p1) {
        // print(p0.percentage);
        // print(p0.message);
        setState(() {
          processPercent = (p0.percentage + 100) / 300;
          currentProcess = p0.message;
        });
      });
    } catch (e) {
      // print("***** error 2");
      // print(e.toString());
      // print("step 6");
    }

    // print("step 7");
    // upload events
    try {
      // print("step 8");
      await D2Touch.trackerModule.event
          // .where(attribute: "synced", value: false)
          .upload((p0, p1) {
        // print(p0.percentage);
        // print(p0.message);

        setState(() {
          processPercent = (p0.percentage + 200) / 300;
          currentProcess = p0.message;
        });
      });
    } catch (e) {
      // print("***** error 3");
      // print(e.toString());
      // print("step 9");
    }

    // print("step 10");

    setState(() {
      uploadingData = false;
    });
  }

  Future<void> setExistingAutosyncConfigs() async {
    final prefs = await SharedPreferences.getInstance();

    bool? autoSyncOn = prefs.getBool("data_upload_auto");
    int? autoSyncInterval = prefs.getInt("data_upload_interval");

    if (autoSyncInterval != null) {
      intervalInputFieldController.text = autoSyncInterval.toString() as String;
    }

    if (autoSyncOn == null) {
      autoUploadOn = false;
    } else {
      autoUploadOn = autoSyncOn as bool;
    }
  }
}
