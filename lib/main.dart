import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/tracker/entities/attribute_reserved_value.entity.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/routes_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.reflectable.dart';

void main() async {
  initializeReflectable();

  var isAuth = await D2Touch.isAuthenticated();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? intervention = await prefs.getString("loggedInItervention");

  runApp(IdsrApp(
    authenticated: isAuth,
    loggedInInterventions: intervention,
  ));
}

class IdsrApp extends StatefulWidget {
  final dynamic authenticated;
  final String? loggedInInterventions;

  const IdsrApp(
      {Key? key, required this.authenticated, this.loggedInInterventions})
      : super(key: key);

  @override
  _IdsrAppState createState() => _IdsrAppState();
}

class _IdsrAppState extends State<IdsrApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eIDSR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
            background: Colors.blueAccent,
            onBackground: Colors.white,
            primary: Colors.blueAccent,
            primaryVariant: Colors.blueAccent,
            onPrimary: Colors.white,
            secondary: Colors.teal,
            secondaryVariant: Colors.teal,
            onSecondary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.teal,
            error: Colors.red,
            onError: Colors.white,
            brightness: Brightness.light),
        // fontFamily: 'Montserrat'
      ),
      // home: IdsrHomePage(title: 'eIDSR Tool'),
      // home: LoginPage(),
      initialRoute: widget.authenticated &&
              widget.loggedInInterventions == 'ibs'
          ? "/ibspage"
          : widget.authenticated && widget.loggedInInterventions == 'ebs'
              ? "/ebspage"
              : widget.authenticated && widget.loggedInInterventions == 'mcbs'
                  ? "/mcbspage"
                  : "/home",
      onGenerateRoute: RoutesGenerator.generateRoute,
    );
  }
}
