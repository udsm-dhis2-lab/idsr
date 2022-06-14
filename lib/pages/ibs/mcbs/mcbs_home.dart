import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/widgets/card_widgets/tools_card_widget.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';

class McbsHomePage extends StatefulWidget {
  const McbsHomePage({Key? key}) : super(key: key);

  @override
  _McbsHomePageState createState() => _McbsHomePageState();
}

class _McbsHomePageState extends State<McbsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("mCBS Tools"),),
        body: Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          // TopNavbarWidget(
          //   navbarLabel: 'IBS',
          //   navbarIcon: 'icon_plus.png',
          // ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  ToolsCard(
                      image: 'immediate_tool.png',
                      toolName: 'Malaria Case Registry',
                      toolDescription:
                          "Register Malaria Patient passively detected at Health Facility",
                      routePath: 'ibspage/malaria'),
                  SizedBox(
                    width: 10,
                  ),
                  ToolsCard(
                      image: 'weekly_tool.png',
                      toolName: 'ReACD Register',
                      toolDescription:
                          'Register Contacts for the passively detected Index Case',
                      routePath: 'ibspage/reacd'),
                ]),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  ToolsCard(
                    image: 'other_tools.png',
                    toolName: 'Pro-ACD Register',
                    routePath: 'ibspage/proacd',
                    toolDescription: 'Register Screened individuals from foci',
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    ));

    // return Scaffold(
    //     body: Container(
    //   width: double.maxFinite,
    //   padding: EdgeInsets.only(left: 15),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text('mCBS Tools',
    //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Container(
    //         width: double.maxFinite,
    //         padding: EdgeInsets.only(left: 15),
    //         child: Row(children: [
    //           ToolsCard(
    //             image: 'immediate_tool.png',
    //             toolName: 'Malaria Case Registry',
    //             icon: Icons.ac_unit,
    //             routePath: '',
    //             toolDescription:
    //                 "Register Malaria Patient passively detected at Health Facility",
    //           ),
    //           SizedBox(
    //             width: 10,
    //           ),
    //           ToolsCard(
    //             image: '',
    //             icon: Icons.ac_unit,
    //             toolName: 'ReACD Register',
    //             routePath: '',
    //             toolDescription:
    //                 "Register Contacts for the passively detected Index Case",
    //           ),
    //         ]),
    //       ),
    //       Container(
    //         width: double.maxFinite,
    //         padding: EdgeInsets.only(left: 15),
    //         child: Row(
    //           children: [
    //             ToolsCard(
    //               image: "",
    //               icon: Icons.ac_unit,
    //               toolName: "Pro-ACD Register",
    //               routePath: "",
    //               toolDescription: "Register Screened individuals from foci",
    //             )
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // ));
  }
}
