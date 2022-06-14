import 'dart:convert';

import 'package:eIDSR/pages/ibs/ibs_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/shared/model/surveillanceSelection_model.dart';
import 'package:eIDSR/shared/widgets/card_widgets/surveillance_card_widget.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List dialogOptionsData = [
    //   {"name": "Logout", "path": ""},
    //   {"name": "Sync", "path": ""},
    //   {"name": "Profile", "path": ""}
    // ];

    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                width: double.maxFinite,
                height: double.maxFinite,
                child: ListView(padding: EdgeInsets.only(top: 100), children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Select Surveillance',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30),
                            ),
                          ),
                          // ClipOval(
                          //   child: Material(
                          //     color: Colors.transparent,
                          //     child: IconButton(
                          //         icon: Icon(
                          //           Icons.more_vert,
                          //           color: Colors.white,
                          //         ),
                          //         tooltip: 'More action',
                          //         onPressed: () {
                          //           showActionsDialog(
                          //               context, dialogOptionsData);
                          //         }),
                          //   ),
                          // ),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            SizedBox(
                              height: 50,
                            ),
                            ...listSurveillanceSelections(context)
                          ])
                        ],
                      ))
                ]))),
        onWillPop: () async {
          //TODO : add logic to check if back will go to login page
          SystemNavigator.pop();

          return true;
        });
  }

  // fucntionalities for home page

  listSurveillanceSelections(context) {
    List<SurveillanceSelection> surveillanceSelections =
        surveillanceSelectionFromJson(
            json.encode(AppConstants.surveillanceSelectionArray));

    return surveillanceSelections
        .map((i) => new SurveillanceCard(
            width: MediaQuery.of(context).size.width * 0.8,
            header: i.header,
            description: i.description,
            icon: i.icon,
            routePath: i.routePath))
        .toList();
  }

  void fetchProgram() async {
    // print(await D2Touch.isAuthenticated());
    final programQuery = D2Touch.programModule.program;
    // final programs = await D2Touch.programModule.program;
    // final program = await programQuery.byId('lxAQ7Zs9VYR').getOne();
    final program = await programQuery.get();
    // print(program);
  }

  void showActionsDialog(BuildContext context, List options) {
    List<SimpleDialogOption> dialogOptions = options.map((option) {
      return SimpleDialogOption(
        child: TextButton(
          child: Text(
            option["name"],
            style: TextStyle(color: Colors.black26),
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
    } else if (action == "Sync") {
      //TODO: add navigation logic
      await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => IBSPage(
                  indexToInherit: 3,
                )),
      );
    } else if (action == "Profile") {}
  }

  void logout(BuildContext context) async {
    final logoutResponse = await D2Touch.logOut();

    // print("logout resp :" + logoutResponse.toString());

    Navigator.of(context).popUntil((route) => route.isFirst);

    Navigator.pushNamed(context, "/");
  }
}
