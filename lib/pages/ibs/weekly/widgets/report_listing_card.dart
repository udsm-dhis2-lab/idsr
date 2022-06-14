import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/model/tackedEntityInstance_model.dart';

class ReportListing extends StatelessWidget {
  // TrackedEntityInstance trackedEntityInstance;

  ReportListing({
    Key? key,
  }) : super(key: key);

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
                    Text('Week 14: 06/10/2021 - 11/10/2021',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none)),
                  ],
                ),
                Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                            icon: Icon(
                              Icons.sync_rounded,
                              color: Colors.blueAccent,
                            ),
                            tooltip: 'Sync',
                            onPressed: () {}),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('Report ID',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.none)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('202004-SHDLS', // caseID
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('Entrant',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.none)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('John Doe'.toString(),
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Divider(),
            Container(
              padding: EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('COMPLETED',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSuccess,
                          decoration: TextDecoration.none)),
                  TextButton.icon(
                    icon: Icon(Icons.visibility_outlined),
                    label: Text(
                      'View',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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
}
