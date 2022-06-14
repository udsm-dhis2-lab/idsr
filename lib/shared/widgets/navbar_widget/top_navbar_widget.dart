import 'package:d2_touch/d2_touch.dart';
import 'package:flutter/material.dart';

class TopNavbarWidget extends StatelessWidget {
  final String navbarIcon;
  final double? navbarIconSize;
  final String navbarLabel;
  final double? navbarLabelSize;

  const TopNavbarWidget(
      {Key? key,
      required this.navbarLabel,
      required this.navbarIcon,
      this.navbarIconSize,
      this.navbarLabelSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List dialogOptionsData = [
      {"name": "Logout", "path": ""},
      {"name": "Sync", "path": ""},
      {"name": "Settings", "path": ""},
      {"name": "Profile", "path": ""},
      {"name": "Switch to EBS", "path": ""}
    ];

    return Container(
      color: Theme.of(context).colorScheme.background,
      // padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      padding: EdgeInsets.only(top: 50, bottom: 10, left: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    }, // Image tapped
                    child: Image.asset(
                      'images/' + this.navbarIcon,
                      fit: BoxFit.cover, // Fixes border issues
                      width: this.navbarIconSize != null
                          ? this.navbarIconSize
                          : 32,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(this.navbarLabel,
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontFamily: 'Montserrat',
                          fontSize: this.navbarLabelSize != null
                              ? this.navbarLabelSize
                              : 28,
                          fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          tooltip: 'More action',
                          onPressed: () {}),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          tooltip: 'More action',
                          onPressed: () {
                            showActionsDialog(context, dialogOptionsData);
                          }),
                    ),
                  )
                ],
              )
            ],
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
            style: TextStyle(color: Colors.black26, fontSize: 20),
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
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
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

  dialogOptionAction(String action, BuildContext context) {
    // print("here" + action);

    if (action == "Logout") {
      logout(context);
    } else {
      //TODO: add navigation logic

    }
  }

  void logout(BuildContext context) async {
    final logoutResponse = await D2Touch.logOut();

    // print("logout resp :" + logoutResponse.toString());

    Navigator.of(context).popUntil((route) => route.isFirst);

    Navigator.pushNamed(context, "/");
  }
}
