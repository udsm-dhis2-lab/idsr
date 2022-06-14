import 'package:d2_touch/d2_touch.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/ibs_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EBSPage extends StatefulWidget {
  const EBSPage({Key? key}) : super(key: key);

  @override
  State<EBSPage> createState() => _EBSPageState();
}

class _EBSPageState extends State<EBSPage> {
  @override
  Widget build(BuildContext context) {
    List dialogOptionsData = [
      {"name": "Logout", "path": ""},
      {"name": "Switch to IBS", "path": ""}
    ];

    return Scaffold(
      appBar: AppBar(title: Text("EBS Page"), actions: [
        IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            tooltip: 'More action',
            onPressed: () {
              showActionsDialog(context, dialogOptionsData);
            })
      ]),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                left: 15,
                right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.construction,
                      color: AppColors.bgPrimary,
                      size: 30,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Page Under Construction",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            logout(context);
                            // await Navigator.push(
                            //   context,
                            //   // Create the SelectionScreen in the next step.
                            //   MaterialPageRoute(
                            //       builder: (context) => IBSPage(
                            //             indexToInherit: 0,
                            //           )),
                            // );
                          },
                          child: Text("Switch to IBS")),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
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
    } else if (action == "Switch to IBS") {
      logout(context);
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
