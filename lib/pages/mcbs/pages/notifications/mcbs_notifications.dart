import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/pages/ibs/weekly/weekly_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/pages/ibs/notification/widgets/notification-list-item.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_appbar_widget.dart';
import 'package:eIDSR/shared/widgets/navbar_widget/top_navbar_widget.dart';
import 'package:week_of_year/date_week_extensions.dart';

class McbsNotifications extends StatefulWidget {
  const McbsNotifications({Key? key}) : super(key: key);

  @override
  _McbsNotificationsState createState() => _McbsNotificationsState();
}

class _McbsNotificationsState extends State<McbsNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: AppColors.whiteSmoke,
      child: SizedBox(
        height: 0,
      ),
    );
  }
}
