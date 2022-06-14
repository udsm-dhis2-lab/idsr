import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';
import 'package:eIDSR/shared/widgets/tracker/case_listing/tracker_case_listing_card.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

class McbsPageToDelete extends StatefulWidget {
  McbsPageToDelete({Key? key}) : super(key: key);

  @override
  State<McbsPageToDelete> createState() => _McbsPageToDeleteState();
}

class _McbsPageToDeleteState extends State<McbsPageToDelete> {
  String selectedOuName = 'AAR Polyclinic';
  bool loading = true;
  List<Widget> trackedEntityInstances = [];

  @override
  void initState() {
    super.initState();
    final caseListingData = loadImmediateCases();
    setState(() {
      trackedEntityInstances = caseListingData;
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          TopNavbarWidget(
            navbarLabel: 'mCBS',
            navbarLabelSize: 24,
            navbarIcon: 'icon_back.png',
            navbarIconSize: 22,
          ),
          Column(
              // height: 300,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 8, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.account_tree_outlined),
                                  label: Text(
                                    '${selectedOuName}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {
                                    showActionsDialog(context);
                                  },
                                )
                              ],
                            ),
                            Column(
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.add_outlined),
                                  label: Text(
                                    'New Case',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/ibspage/mcbs/dataentry');
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                        // 166 was the overflowing pixels
                        height: MediaQuery.of(context).size.height - 166,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [...trackedEntityInstances]),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ],
      ),
    );
  }

  loadImmediateCases() {
    return [];
  }

  Future<void> showActionsDialog(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );

    setState(() {
      selectedOuName = result.map((orgUnit) {
        return orgUnit.name;
      }).join(",");
    });
  }
}
