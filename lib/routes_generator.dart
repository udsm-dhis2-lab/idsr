import 'package:eIDSR/pages/ebs/login/ebs_login.dart';
import 'package:eIDSR/pages/ibs/login/ibs_login.dart';
import 'package:eIDSR/pages/ibs/mcbs/pages/mcbs_page.dart';
import 'package:eIDSR/pages/mcbs/login/mcbs_login.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/pages/ebs/ebs_page.dart';
import 'package:eIDSR/pages/home/home_page.dart';
import 'package:eIDSR/pages/ibs/ibs_home_page.dart';
import 'package:eIDSR/pages/ibs/immediate/immediate_page.dart';
import 'package:eIDSR/pages/ibs/mcbs/mcbs_home.dart';
import 'package:eIDSR/pages/mcbs/pages/tools/mcbs_tools/malaria_registry.dart';
import 'package:eIDSR/pages/ibs/mcbs/pages/mcbs_dataentry.dart';
import 'package:eIDSR/pages/mcbs/pages/tools/mcbs_tools/proacd_registry.dart';
import 'package:eIDSR/pages/mcbs/pages/tools/mcbs_tools/reacd_registry.dart';
import 'package:eIDSR/pages/ibs/weekly/weekly_dataentry.dart';
import 'package:eIDSR/pages/ibs/weekly/weekly_page.dart';
import 'package:eIDSR/pages/login/login_page.dart';
import 'package:eIDSR/shared/widgets/org_unit_widgets/orgunit_widgets.dart';

import 'pages/ibs/mcbs/pages/malaria_registry/malaria_registry_data_entry.dart';

class RoutesGenerator {
  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    // final authenticated = await D2Touch.isAuthenticated();

    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/ibspage':
        return MaterialPageRoute(builder: (_) => IBSPage());
      case '/ibslogin':
        return MaterialPageRoute(builder: (_) => IbsLoginPage());
      case '/mcbspage':
        return MaterialPageRoute(builder: (_) => McbsPageToDelete());
      case '/mcbslogin':
        return MaterialPageRoute(builder: (_) => McbsLoginPage());
      case '/ebspage':
        return MaterialPageRoute(builder: (_) => EBSPage());
      case '/ebslogin':
        return MaterialPageRoute(builder: (_) => EbsLoginPage());
      case '/ouPicker':
        return MaterialPageRoute(builder: (_) => OrganisationUnitWidget());
      case '/ibspage/immediate':
        return MaterialPageRoute(builder: (_) => ImmediateProgramPage());
      case '/ibspage/weekly':
        return MaterialPageRoute(builder: (_) => WeeklyPage());
      // case '/ibspage/weekly/dataentry':
      //   return MaterialPageRoute(builder: (_) => WeeklyDataEntry());
      case '/ibspage/mcbs':
        // return MaterialPageRoute(builder: (_) => McbsPage());
        return MaterialPageRoute(builder: (_) => McbsHomePage());
      case '/ibspage/mcbs/dataentry':
        return MaterialPageRoute(builder: (_) => McbsDataEntryPage());
      case '/mcbs/malaria':
        return MaterialPageRoute(builder: (_) => MalariaRegistry());
      case '/ibspage/malaria/dataentry':
        return MaterialPageRoute(builder: (_) => MalariaDataEntryPage());
      case '/mcbs/reacd':
        return MaterialPageRoute(builder: (_) => ReAcdRegister());
      case '/mcbs/proacd':
        return MaterialPageRoute(builder: (_) => ProacdRegistry());
      case '/ibspage/mcbs/malaria/dataentry':
        return MaterialPageRoute(builder: (_) => MalariaRegistry());
      // case '/ebspage':
      //   return MaterialPageRoute(builder: (_) => EBSPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(child: Text("ERROR")),
      );
    });
  }
}
