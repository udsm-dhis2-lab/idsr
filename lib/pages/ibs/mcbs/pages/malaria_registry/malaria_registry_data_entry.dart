import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_tracked_entity_attribute.entity.dart';
import 'package:d2_touch/modules/metadata/program/queries/program_tracked_entity_attribute.query.dart';
import 'package:eIDSR/shared/widgets/tracker/data_entry/tracker_section_form_card.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

class MalariaDataEntryPage extends StatefulWidget {
  MalariaDataEntryPage({Key? key}) : super(key: key);

  @override
  State<MalariaDataEntryPage> createState() => _MalariaDataEntryPageState();
}

class _MalariaDataEntryPageState extends State<MalariaDataEntryPage> {
  List mcbsformSections = [];
  String selectedOuName = 'AAR Polyclinic';

  @override
  void initState() {
    super.initState();
    setState(() {
      // mcbsformSections = formSections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          getTrackerMetadata();
        },
        child: Text("test"));

    // return Container(
    //   width: double.maxFinite,
    //   height: double.maxFinite,
    //   color: AppColors.whiteSmoke,
    //   child: Column(
    //     children: [
    //       TopNavbarWidget(
    //         navbarLabel: 'DataEntry',
    //         navbarLabelSize: 24,
    //         navbarIcon: 'icon_back.png',
    //         navbarIconSize: 22,
    //       ),
    //       Column(
    //         children: [
    //           Container(
    //             child: Column(
    //               children: [
    //                 Container(
    //                   decoration:
    //                       BoxDecoration(color: Colors.white, boxShadow: [
    //                     BoxShadow(
    //                       color: Colors.grey.withOpacity(0.1),
    //                       spreadRadius: 4,
    //                       blurRadius: 5,
    //                       offset: Offset(0, 3), // changes position of shadow
    //                     ),
    //                   ]),
    //                   padding: EdgeInsets.only(
    //                       top: 5, bottom: 5, left: 8, right: 10),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Column(
    //                         children: [
    //                           TextButton.icon(
    //                             icon: Icon(
    //                               Icons.account_tree_outlined,
    //                               color: AppColors.textMuted,
    //                             ),
    //                             label: Text(
    //                               '${selectedOuName}',
    //                               style: TextStyle(
    //                                   fontSize: 15, color: AppColors.textMuted),
    //                             ),
    //                             onPressed: () {
    //                               showActionsDialog(context);
    //                             },
    //                           )
    //                         ],
    //                       ),
    //                       Column(
    //                         children: [
    //                           TextButton(
    //                             child: Text('MCR_123456',
    //                                 style:
    //                                     TextStyle(color: AppColors.textMuted)),
    //                             onPressed: null,
    //                           ),
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: 15, left: 10, right: 10),
    //                   // 166 was the overflowing pixels
    //                   height: MediaQuery.of(context).size.height - 166,
    //                   child: SingleChildScrollView(
    //                     scrollDirection: Axis.vertical,
    //                     child: Column(children: [
    //                       ...renderImmediateFromSections(),
    //                       Container(
    //                         padding: EdgeInsets.only(
    //                             top: 10, bottom: 10, right: 5, left: 5),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             ElevatedButton.icon(
    //                                 style: ButtonStyle(
    //                                     minimumSize: MaterialStateProperty.all(
    //                                         Size(200, 50)),
    //                                     elevation:
    //                                         MaterialStateProperty.all<double>(
    //                                             0)),
    //                                 onPressed: () {
    //                                   Navigator.pop(context);
    //                                 },
    //                                 icon: Icon(Icons.save_outlined),
    //                                 label: AppText(
    //                                   text: 'Save',
    //                                   textColor: 'white',
    //                                   fontSize: 23,
    //                                 )),
    //                           ],
    //                         ),
    //                       )
    //                     ]),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }

  getTrackerMetadata() async {
    final List<ProgramTrackedEntityAttribute> malariaRegistryFormMetadata =
        await ProgramTrackedEntityAttributeQuery()
            .where(attribute: "program", value: "ib6PYHQ5Aa8")
            .withOptions()
            .get();

    // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    // print(malariaRegistryFormMetadata);
    // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  }

  renderImmediateFromSections() {
    // return mcbsformSections
    //     .map<Widget>((i) => TrackerFormCardSection(formSection: i))
    //     .toList();
  }

  formSections() async {
    await D2Touch.programModule.program.withProgramStages().byId("ib6PYHQ5Aa8");

    final malariaRegistryFormMetadata =
        await ProgramTrackedEntityAttributeQuery()
            .where(attribute: "program", value: "ib6PYHQ5Aa8")
            .withOptions()
            .get();

    // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    // print(malariaRegistryFormMetadata);
    // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    return AppConstants.mcbsFormSection
        .map((formSection) => updateFormSection(formSection))
        .toList();
  }

  updateFieldData(field, trackeEntityAttributes) {
    List filteredAttribute = trackeEntityAttributes
        .where((item) => item['trackedEntityAttribute']['id'] == field['id'])
        .toList();
    return filteredAttribute.length > 0
        ? {
            ...?filteredAttribute[0]['trackedEntityAttribute'],
            'mandatory': filteredAttribute[0]['mandatory']
          }
        : {};
  }

  updateFieldGroupData(fieldGroup) {
    final updatedFields = (fieldGroup['fields'] ?? [])
        .map((field) => updateFieldData(field, []))
        .toList();
    return {...fieldGroup, 'fields': updatedFields};
  }

  updateFormSection(formSection) {
    final updatedFieldGroups = (formSection['fieldGroups'] ?? [])
        .map((fieldGroup) => updateFieldGroupData(fieldGroup))
        .toList();
    return {...formSection, "fieldGroups": updatedFieldGroups};
  }

  Future<void> showActionsDialog(BuildContext context) async {
    final List<OrganisationUnit> result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OrganisationUnitWidget()),
    );

    // print("selected ous :::  " + result.toString());

    setState(() {
      selectedOuName = result.map((orgUnit) {
        return orgUnit.name;
      }).join(",");
    });
  }
}
