import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:eIDSR/pages/ebs/ebs_page.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/notification/notification_home.dart';
import 'package:eIDSR/pages/ibs/summary/summary_home.dart';
import 'package:eIDSR/pages/ibs/synchronization/sync_home.dart';
import 'package:eIDSR/pages/ibs/tools/tools_home.dart';
import 'package:eIDSR/shared/widgets/card_widgets/tools_card_widget.dart';
import 'package:eIDSR/shared/widgets/card_widgets/user_welcome_widget.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/bottom_navbar_widget.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IBSPage extends StatefulWidget {
  final int? indexToInherit;

  const IBSPage({Key? key, this.indexToInherit: null}) : super(key: key);

  @override
  _IBSPageState createState() => _IBSPageState();
}

class IBSPages {
  Widget page;
  Widget header;
  bool showBackNavigation;
  final int selectedIndex;

  IBSPages(
      {required this.page,
      required this.header,
      this.selectedIndex: 0,
      this.showBackNavigation: true});
}

class _IBSPageState extends State<IBSPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex =
        widget.indexToInherit == null ? 0 : widget.indexToInherit as int;
  }

  List<Widget> pages = [Tools(), SummaryHome(), NotificationHome(), SyncHome()];
  List<dynamic> pageTileConfigs = [
    {
      "title": Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Row(children: [
            Icon(
              Icons.add_box_rounded,
              color: Colors.greenAccent,
            ),
            Text("IBS")
          ])),
    },
    {
      "title": Text("Summary"),
    },
    {
      "title": Text("Notification"),
    },
    {
      "title": Text("Sync"),
    }
  ];

  void onTapNavBarItem(int itemIndex) {
    // print("the inderx :: " + itemIndex.toString());
    setState(() {
      currentIndex = itemIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List dialogOptionsData = [
      {"name": "Logout", "path": ""},
      {"name": "Sync", "path": ""},
      {"name": "Profile", "path": ""},
      {"name": "Switch to EBS", "path": ""}
    ];

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leadingWidth:
              currentIndex == 0 ? 0 : MediaQuery.of(context).size.width * 0.1,
          leading: currentIndex == 0
              ? SizedBox(
                  height: 0,
                  width: 0,
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  tooltip: '',
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  }),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            pageTileConfigs[currentIndex]["title"],
            SizedBox(
              width: 0,
            )
          ]),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                tooltip: 'More action',
                onPressed: () {
                  showActionsDialog(context, dialogOptionsData);
                })
          ],
        ),
        body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView(children: [pages[currentIndex]])),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTapNavBarItem,
          currentIndex: currentIndex,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          // elevation: 5,
          items: [
            BottomNavigationBarItem(
                label: 'Tools', icon: Icon(Icons.description_outlined)),
            BottomNavigationBarItem(
                label: 'Summary', icon: Icon(Icons.bar_chart_rounded)),
            BottomNavigationBarItem(
                label: 'Notification',
                icon: new Stack(children: <Widget>[
                  new Icon(Icons.notifications_rounded),
                  new Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: new Icon(Icons.brightness_1,
                        size: 8.0, color: Colors.redAccent),
                  )
                ])),
            BottomNavigationBarItem(
                label: 'Sync', icon: Icon(Icons.sync_rounded))
          ],
        ));
  }

  void showActionsDialog(BuildContext context, List options) {
    List<SimpleDialogOption> dialogOptions = options.map((option) {
      return SimpleDialogOption(
        child: TextButton(
          child: Text(
            option["name"],
            style: TextStyle(
              color: Colors.black26,
            ),
          ),
          onPressed: () {
            dialogOptionAction(option["name"], context);
          },
        ),
      );
    }).toList();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            children: [
              SimpleDialogOption(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                          tooltip: 'More action',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              )),
              ...dialogOptions
            ],
          );
        });
  }

  dialogOptionAction(String action, BuildContext context) async {
    // print("here" + action);

    if (action == "Logout") {
      logout(context);
    } else if (action == ("Sync")) {
      setState(() {
        currentIndex = 3;
      });

      Navigator.pop(context);
    } else if (action == "Switch to EBS") {

      logout(context);

      // await Navigator.push(
      //   context,
      //   // Create the SelectionScreen in the next step.
      //   MaterialPageRoute(builder: (context) => EBSPage()),
      // );
    }
  }

  void logout(BuildContext context) async {
    final logoutResponse = await D2Touch.logOut();

    // print("logout resp :" + logoutResponse.toString());

    // Navigator.of(context).popUntil((route) => route.isFirst);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("loggedInItervention");

    Navigator.pushNamed(context, "/home");
  }
}
