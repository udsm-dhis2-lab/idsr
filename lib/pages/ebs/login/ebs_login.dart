import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/auth/user/models/login-response.model.dart';
import 'package:eIDSR/pages/ebs/ebs_page.dart';
import 'package:eIDSR/pages/ibs/login/ibs_metadata_sync.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/pages/login/widgets/metadata_sync_widget.dart';
import 'package:eIDSR/shared/widgets/loaders/circular_progress_loader.dart';
import 'package:eIDSR/shared/widgets/text_widgets/text_widget.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EbsLoginPage extends StatefulWidget {
  const EbsLoginPage({Key? key}) : super(key: key);

  @override
  _EbsLoginPageState createState() => _EbsLoginPageState();
}

class _EbsLoginPageState extends State<EbsLoginPage> {
  String username = '';
  String password = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool authenticating = false;
  bool showPassWord = false;
  bool loggedIn = true;
  bool errorLoginIn = false;
  late String errorMessage;

  checkAuth() async {
    bool authState = await D2Touch.isAuthenticated();

    setState(() {
      loggedIn = authState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration:
        BoxDecoration(color: Theme.of(context).colorScheme.background),
        width: double.maxFinite,
        height: double.maxFinite,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: TextWidgetBold(
                text: "eIDSR",
                size: 25,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                EdgeInsets.only(top: 20, bottom: 30, right: 20, left: 20),
                margin: EdgeInsets.only(left: 40, right: 40, top: 20),
                child: Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        TextWidgetBold(
                          text: "Login",
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 25,
                          bottom: 20,
                        ),
                        TextWidget(
                            text:
                            'Please enter your account details in order to login to the app',
                            color: Colors.black54,
                            size: 15,
                            bottom: 20),
                        errorLoginIn
                            ? Text(
                          "Error logging in. Please confirm your credentials and retry",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        )
                            : SizedBox(
                          height: 0,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outlined),
                                border: UnderlineInputBorder(),
                                labelText: 'Username',
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 15, bottom: 25),
                            child: TextFormField(
                              obscureText: !showPassWord,
                              controller: passwordController,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined),
                                // suffixIcon: Icon(Icons.person,),
                                suffixIcon: IconButton(
                                  icon: showPassWord
                                      ? Icon(Icons.visibility_sharp)
                                      : Icon(Icons.visibility_off_outlined),
                                  onPressed: () {
                                    setState(() {
                                      showPassWord = !showPassWord;
                                    });
                                  },
                                ),
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                              ),
                            )),
                        Container(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  username = usernameController.text;
                                  password = passwordController.text;
                                  authenticating = true;
                                  errorMessage = "";
                                  errorLoginIn = false;
                                });
                                _login(username, password);
                              },
                              child: authenticating == false
                                  ? Text("Login",
                                  style: TextStyle(color: Colors.white))
                                  : CircularProgressLoader("Authenticating"),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(left: 30, right: 30)))),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  // Functionalities for logging IN HERE
  _login(String username, String password) async {
    setState(() {
      authenticating = true;
    });

    LoginResponseStatus? onlineLogIn;

    try {
      onlineLogIn = await D2Touch.logIn(
          username: username,
          password: password,
          url: AppConstants.dhisInstance);
    } catch (error) {
      // print("*************************************");
      // print(error);
      // print("*************************************");

      onlineLogIn = null;

      setState(() {
        errorLoginIn = true;
        authenticating = false;
      });
    }

    // print("*********");
    // print(onlineLogIn);
    // print("*********");

    bool isAuthenticated = await D2Touch.isAuthenticated();

    // print(onlineLogIn);
    // print(isAuthenticated);

    if (isAuthenticated) {


      // set intervention to share prefs
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("loggedInItervention", "ebs");

      setState(() => {
        authenticating = false,
        loggedIn = false,
        errorLoginIn = false,
      });

      // TODO sync ebs metadata before navigating
      // final bool? result = await Navigator.push(
      //   context,
      //   // Create the SelectionScreen in the next step.
      //   MaterialPageRoute(builder: (context) => IbsMetadataSyncWidget()),
      // );

      // add logic to show message

      try {
        // Navigator.pushNamed(context, '/home');

        final dynamic backToLogin = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => EBSPage()));

        SystemNavigator.pop();
      } catch (error) {
        // print(error.toString());
      }
    } else {
      //logic to show error widget

      setState(() => {
        authenticating = false,
        loggedIn = false,
        errorLoginIn = true,
        errorMessage = "error message"
      });
    }
  }
}
