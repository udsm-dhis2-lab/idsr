import 'dart:convert';

import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:eIDSR/shared/model/aggregate_form_section_model.dart';
import 'package:eIDSR/shared/model/custom_dataelement_model.dart';
import 'package:eIDSR/shared/widgets/text_widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/weekly/widgets/aggregate_section_form_card.dart';

// import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

class WeeklyDataEntry extends StatefulWidget {
  DataValueSet dataValueSet;
  String datasetId;
  OrganisationUnit selectedOrgUnit;
  List<CustomDataElement> datasetDataElement;

  WeeklyDataEntry(
      {Key? key,
      required this.dataValueSet,
      required this.datasetId,
      required this.selectedOrgUnit,
      required this.datasetDataElement})
      : super(key: key);

  @override
  State<WeeklyDataEntry> createState() => _WeeklyDataEntryState();
}

class _WeeklyDataEntryState extends State<WeeklyDataEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Weekly Report"),
        ),
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: AppColors.whiteSmoke,
          child: Column(
            children: [
              // TopNavbarWidget(
              //   navbarLabel: 'Data Entry',
              //   navbarLabelSize: 24,
              //   navbarIcon: 'icon_back.png',
              //   navbarIconSize: 22,
              // ),
              Column(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Column(
                                  children: [
                                    TextButton.icon(
                                      icon: Icon(
                                        Icons.account_tree_outlined,
                                        color: AppColors.textMuted,
                                      ),
                                      label: Text(
                                        '${widget.selectedOrgUnit.name}',
                                        style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  TextButton(
                                    child: Text(
                                        "Week " +
                                            widget.dataValueSet.period
                                                .split("W")[1],
                                        style: TextStyle(
                                            color: AppColors.textMuted)),
                                    onPressed: null,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 10, right: 10),
                          // 166 was the overflowing pixels
                          height: MediaQuery.of(context).size.height - 166,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              ...loadAggregateFormSections(),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 5, left: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            showSavingOptions();
                                          },
                                          // icon: Icon(Icons.save_outlined),
                                          child: Text("SAVE")
                                          /* AppText(
                                            text: 'COMPLETE',
                                            textColor: 'white',
                                            fontSize: 20,
                                          )*/
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  loadAggregateFormSections() {
    // final response = await D2Touch.
    List<AggregateFormSection> aggregateFormSection =
        aggregateFormSectionFromJson(
            json.encode(AppConstants.weeklyFormSection));
    return aggregateFormSection
        .map<Widget>((i) => AggregateFormCardSection(
            datasetId: widget.datasetId,
            datasetDataElements: widget.datasetDataElement,
            formSection: i,
            dataValueSet: widget.dataValueSet))
        .toList();
  }

  showSavingOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_outlined),
                    )
                  ],
                ),
                Column(
                  children: [
                    widget.dataValueSet.completeDate != null &&
                            widget.dataValueSet.completeDate != ''
                        ? SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: const Text('COMPLETE AND SAVE'),
                                  onPressed: () {
                                    completeSaveAndNavigate();
                                  },
                                ),
                              ),
                            ],
                          ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('SAVE'),
                            onPressed: () {
                              saveAndNavigate();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  saveAndNavigate() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data saved succesfully'),
      backgroundColor: AppColors.textSuccess,
    ));
  }

  Future<void> completeSaveAndNavigate() async {
    DataValueSet dataValueSetToUpdate = await D2Touch
        .aggregateModule.dataValueSet
        .byId(widget.dataValueSet.id as String)
        .getOne();

    String date = DateTime.now().toIso8601String().split('.')[0];
    dataValueSetToUpdate.completeDate = date;

    await D2Touch.aggregateModule.dataValueSet
        .setData(dataValueSetToUpdate)
        .save();

    Navigator.of(context).pop();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Report saved and completed succesfully'),
      backgroundColor: AppColors.textSuccess,
    ));
  }

  Future<void> showActionsDialog(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );

    // setState(() {
    //   selectedOuName = result.map((orgUnit) {
    //     return orgUnit.name;
    //   }).join(",");
    // });
  }

  // TrackedEntityInstance trackedEntityInstance,
  onFieldInputChange(field, value) async {
    // final TrackedEntityAttributeValue trackedEntityAttributeValue =
    //     TrackedEntityAttributeValue(
    //         id: '${newCaseTrackedEntityInstanceUid}_${field.attribute}',
    //         name: '${newCaseTrackedEntityInstanceUid}_${field.attribute}',
    //         dirty: true,
    //         attribute: field.attribute,
    //         trackedEntityInstance: newCaseTrackedEntityInstanceUid,
    //         value: value);
    final dataValueSetpayload = {
      "dataSet": "BfMAe6Itzgt",
      "period": "2022W1",
      "orgUnit": "bG0PlyD0iP3",
      "dataValues": [
        {
          "dataElement": "UOlfIjgN8X6",
          "period": "202201",
          "orgUnit": "bG0PlyD0iP3",
          "categoryOptionCombo": "V6L425pT3A0",
          "attributeOptionCombo": "HllvX50cXC0",
          "value": "5",
          "storedBy": "bo2",
          "created": "2014-11-06T09:13:11.000+0000",
          "lastUpdated": "2010-03-06T00:00:00.000+0000",
          "followup": false
        }
      ]
    };
    final DataValueSet dataValueSet =
        DataValueSet.fromJson({...dataValueSetpayload, 'dirty': true});
    // final DataValueSet dataValueSet = DataValueSet(id: id, name: name, period: period, orgUnit: orgUnit, synced: synced, dataSet: dataSet, dirty: dirty)
    await D2Touch.aggregateModule.dataValueSet.setData(dataValueSet).save();
  }
}
