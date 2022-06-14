import 'package:d2_touch/d2_touch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/widgets/synchronization/data_clear.dart';
import 'package:eIDSR/shared/widgets/synchronization/data_upload.dart';
import 'package:eIDSR/shared/widgets/synchronization/metadata_download.dart';
import 'package:eIDSR/shared/widgets/synchronization/sync_option_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class McbsSync extends StatefulWidget {
  const McbsSync({Key? key}) : super(key: key);

  @override
  _McbsSyncState createState() => _McbsSyncState();
}

class SyncOption {
  bool expanded;
  Widget header;
  int index;

  SyncOption({
    this.expanded: false,
    required this.index,
    required this.header,
  });
}

class _McbsSyncState extends State<McbsSync> {
  String lastMetadatSyncTime = "";

/*
  downloadMetaData() async {
    await D2Touch.organisationUnitModule.organisationUnit.download((p0, p1) {
      // print(p0.percentage);
      // print(p0.message);
      // print(p1);
    });

    await D2Touch.dataSetModule.dataSet.download((p0, p1) {
      // print(p0.percentage);
      // print(p0.message);
      // print(p1);
    });

    await D2Touch.programModule.program.download((p0, p1) {
      // print(p0.percentage);
      // print(p0.message);
      // print(p1);
    });
  }
*/
  List<SyncOption> syncOptionsList = [
    SyncOption(
        index: 0,
        header: SyncOptionHeader(
          title: "UPLOAD DATA",
          info: "Last update Dec 7,2021. 2.42.11 PM",
          icon: Icons.cloud_upload,
          color: Colors.blueAccent,
        )),
    SyncOption(
        index: 1,
        header: SyncOptionHeader(
          title: "DOWNLOAD METADATA",
          info: "",
          icon: Icons.cloud_download,
          color: Colors.blueAccent,
        )),
    SyncOption(
        index: 2,
        header: SyncOptionHeader(
          title: "CLEAR LOCAL DATA",
          info: "Data cleared last  Dec 7,2021. 2.42.11 PM",
          icon: Icons.delete,
          color: Colors.redAccent,
        )),
  ];

  void onMetaDataSyncComplete() {
    // print("update last sync time");
  }

  Future<String> getLastSynchronizationsTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 1));
    String? lastSyncTime = await prefs.getString("last_metadata_sync");

    if (lastSyncTime == null) {
      return "";
    } else {
      setState(() {
        lastMetadatSyncTime = "Last sync at " + lastSyncTime as String;
      });
      return (lastSyncTime as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(children: [
        FutureBuilder(
            future: getLastSynchronizationsTime(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Container(
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        syncOptionsList[index].expanded = !isExpanded;
                      });
                    },
                    children: syncOptionsList.map((SyncOption option) {
                      return ExpansionPanel(
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return option.index == 0
                                ? SyncOptionHeader(
                                    title: "UPLOAD DATA",
                                    info: "Last update Dec 7,2021. 2.42.11 PM",
                                    icon: Icons.cloud_upload,
                                    color: Colors.blueAccent,
                                  )
                                : option.index == 1
                                    ? SyncOptionHeader(
                                        title: "DOWNLOAD METADATA",
                                        info: "$lastMetadatSyncTime",
                                        icon: Icons.cloud_download,
                                        color: Colors.blueAccent,
                                      )
                                    : option.index == 2
                                        ? SyncOptionHeader(
                                            title: "CLEAR LOCAL DATA",
                                            info:
                                                "Data cleared last  Dec 7,2021. 2.42.11 PM",
                                            icon: Icons.delete,
                                            color: Colors.redAccent,
                                          )
                                        : Text("");
                          },
                          body: option.index == 0
                              ? DataUpload()
                              : option.index == 1
                                  ? MetadataDownload(intervention: 'mcbs',onSyncComplete: () {
                                      getLastSynchronizationsTime();
                                    })
                                  : option.index == 2
                                      ? DataClear()
                                      : Text(""),
                          isExpanded: option.expanded);
                    }).toList(),
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2))),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Loading Settings...',
                                style: TextStyle(color: AppColors.textPrimary),
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
      ]),
    );
  }
}
