import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:eIDSR/pages/ibs/weekly/weekly_dataentry.dart';
import 'package:eIDSR/shared/model/custom_dataelement_model.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';

class NewReportListing extends StatefulWidget {
  final String datasetId;
  final List<CustomDataElement> datasetDataElements;
  final OrganisationUnit selectedOrganisationUnit;
  final String period;
  final DateTime periodStartDate;
  final DateTime periodEndDate;

  const NewReportListing(
      {Key? key,
      required this.datasetId,
      required this.datasetDataElements,
      required this.selectedOrganisationUnit,
      required this.periodEndDate,
      required this.periodStartDate,
      required this.period})
      : super(key: key);

  @override
  _NewReportListingState createState() => _NewReportListingState();
}

class _NewReportListingState extends State<NewReportListing> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "WEEK " +
                              widget.period.split("W")[1] +
                              " : " +
                              sanitizedDateFormat(
                                  widget.periodStartDate.toIso8601String()) +
                              " - " +
                              sanitizedDateFormat(
                                  widget.periodEndDate.toIso8601String()),
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.none)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        addNewReport();
                      },
                      icon: Icon(Icons.add_outlined, color: AppColors.bgPrimary,),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  sanitizedDateFormat(String dateString) {
    DateTime sanitizedDate = DateTime.parse(dateString);

    return '${sanitizedDate.year.toString()}/${sanitizedDate.month.toString().padLeft(2, '0')}/${sanitizedDate.day.toString().padLeft(2, '0')}';
  }

  addNewReport() async {
    DataValueSet dataValueSet = new DataValueSet(
        period: widget.period,
        orgUnit: widget.selectedOrganisationUnit.id as String,
        synced: false,
        dataSet: widget.datasetId,
        dirty: false);

    try {
      await D2Touch.aggregateModule.dataValueSet.setData(dataValueSet).save();
    } catch (e) {
      // print("error creating dataset");
      // print(e);
    }

    DataValueSet savedDataValueSet = await D2Touch.aggregateModule.dataValueSet
        .where(attribute: "period", value: widget.period)
        .where(
            attribute: "orgUnit",
            value: widget.selectedOrganisationUnit.id as String)
        .where(attribute: "dataSet", value: widget.datasetId)
        .getOne();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WeeklyDataEntry(
                selectedOrgUnit: widget.selectedOrganisationUnit,
                dataValueSet: savedDataValueSet,
                datasetDataElement: widget.datasetDataElements,
                datasetId: widget.datasetId,
              )),
    );
  }
}

/*class NewReportListing extends StatelessWidget {
  // TrackedEntityInstance trackedEntityInstance;
  String datasetId;
  List<CustomDataElement> datasetDataElements;

  NewReportListing(
      {Key? key, required this.datasetId, required this.datasetDataElements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Week 6: 07/02/2021 - 13/02/2021',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none)),
                  ],
                ),
                Column(
                  children: [
                    TextButton.icon(
                        onPressed: () {

                          DataValueSet dataValueSet = new DataValueSet(period: period, orgUnit: , synced: false, dataSet:  , dirty: false)

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeeklyDataEntry(
                                      datasetDataElement: datasetDataElements,
                                      datasetId: datasetId,
                                    )),
                          );
                        },
                        icon: Icon(Icons.add_outlined),
                        label: Text('Report',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.none))),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
*/
// sanitizedDateFormat(String dateString) {
//   DateTime sanitizedDate = DateTime.parse(dateString);

//   return '${sanitizedDate.year.toString()}-${sanitizedDate.month.toString().padLeft(2, '0')}-${sanitizedDate.day.toString().padLeft(2, '0')}';
// }

// getAttributeValue(attribute, String attributeId) {
//   List<Attribute> caseIdAttribute = attribute
//       .where((Attribute attribute) => attribute.attribute == attributeId)
//       .toList();
//   return caseIdAttribute[0].value;
// }
//}
