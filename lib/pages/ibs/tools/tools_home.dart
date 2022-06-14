import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/auth/user/entities/user.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/widgets/card_widgets/tools_card_widget.dart';
import 'package:eIDSR/shared/widgets/card_widgets/user_welcome_widget.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/program/queries/program_tracked_entity_attribute.query.dart';
import 'package:flutter/material.dart';

class Tools extends StatefulWidget {
  const Tools({Key? key}) : super(key: key);

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          UserWelcomeCard(
            header: 'Welcome ${currentUser?.name ?? ''}',
            description:
                'This is week 13 and it looks like you have not reported yet for week 9. Timely report insures you correctness of data and timely submission.',
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('General Tools',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Column(
                    children: [
                      ToolsCard(
                          image: 'immediate_tool.png',
                          toolName: 'Immediate Report',
                          routePath: 'ibspage/immediate'),
                    ],
                  ),
                  Column(
                    children: [
                      ToolsCard(
                          image: 'weekly_tool.png',
                          toolName: 'Weekly Report',
                          routePath: 'ibspage/weekly')
                    ],
                  ),
                ]),
              ],
            ),
          ),
          /*
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Other Tools by Program',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Column(
                    children: [
                      ToolsCard(
                          image: 'other_tools.png',
                          toolName: 'Malaria mCBS',
                          routePath: 'ibspage/mcbs'),
                    ],
                  )
                ]),
              ],
            ),
          ),
          */
        ],
      ),
    );
  }

  getCurrentUserInfo() async {
    User? userInfo = await D2Touch.userModule.user.getOne();
    // final userInfoOU = await D2Touch.userModule.userOrganisationUnit.getOne();

    setState(() {
      currentUser = userInfo!;
    });
    // // print(userInfo?.name.toString());
    // // print(userInfoOU.);
  }
}
