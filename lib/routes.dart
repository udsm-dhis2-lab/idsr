import 'package:flutter/widgets.dart';
import 'package:eIDSR/pages/ebs/ebs_page.dart';
import 'package:eIDSR/pages/ibs/ibs_home_page.dart';
import '/pages/login/login_page.dart';
import '/pages/home/home_page.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/ibspage': (BuildContext context) => IBSPage(),
  '/ebspage': (BuildContext context) => EBSPage()
};
