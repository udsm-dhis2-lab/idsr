import 'package:dhis2_flutter_sdk/d2_touch.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/entities/organisation_unit.entity.dart';
import 'package:dhis2_flutter_sdk/modules/metadata/organisation_unit/queries/organisation_unit.query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrgUnitSelector with ChangeNotifier {
  bool multiple;
  String? loadingOuChildren;
  List<OrganisationUnit> selected = [];

  OrgUnitSelector({this.multiple = false});

  select(OrganisationUnit organisationUnit) {
    if (!this.multiple) {
      selected.clear();
    }
    selected.add(organisationUnit);
    notifyListeners();
  }

  loadingChildren(OrganisationUnit organisationUnit) {
    loadingOuChildren = organisationUnit.id;
    notifyListeners();
  }

  finishedLoading(OrganisationUnit organisationUnit) {
    loadingOuChildren = null;
    //notifyListeners();
  }

  deselect(OrganisationUnit organisationUnit) {
    if (!this.multiple) {
      selected.clear();
    } else {
      selected
          .removeWhere((selectedOu) => organisationUnit.id == selectedOu.id);
    }
    notifyListeners();
  }

  bool isSelected(OrganisationUnit organisationUnit) {
    List<OrganisationUnit> selectedFilter = selected
        .where((selectedOu) => organisationUnit.id == selectedOu.id)
        .toList();
    return selectedFilter.length > 0;
  }
}

class OrganisationUnitWidget extends StatefulWidget {
  bool multiple;

  OrganisationUnitWidget({this.multiple: false});

  @override
  _OrganisationUnitWidgetState createState() => _OrganisationUnitWidgetState();
}

class _OrganisationUnitWidgetState extends State<OrganisationUnitWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Organisation Unit Selection'),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) => OrgUnitSelector(multiple: widget.multiple)),
          ],
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 2.0,
                  child: FutureBuilder<List<OrganisationUnit>>(
                      future: OrganisationUnitQuery().getUserOrgUnits(),
                      // OrganisationUnitQuery()
                      //     .where(attribute: "level", value: 1)
                      //     .get(),
                      // D2Touch.organisationUnitModule.organisationUnit
                      //     .where(attribute: "level", value: 1).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data?.length == 0) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.info_outline),
                                  Text(
                                    'No Organisation Units. Please sync organisation units',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ); //Text('No Organisation Units. Please sync data to ensure the organistion unit');

                          } else {
                            return ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, listSnapshot) {
                                  return Column(
                                    children:
                                        (snapshot.data as List).map((orgUnit) {
                                      //return Text(orgUnit.displayName);
                                      return OrganisationUnitParent(orgUnit);
                                    }).toList(),
                                  );
                                });
                          }
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.info_outline),
                                Text(
                                  'Error Loading Organisation Units - ' +
                                      snapshot.error.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ) //Text('Error Loading Organisation Units?')
                              );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getContainer(),
                ],
              ),
            ],
          ),
        ));
  }

  _getContainer() {
    return Consumer<OrgUnitSelector>(builder: (context, orgUnitSelector, _) {
      return Container(
        height: 45.0,
        width: 200,
        child: GestureDetector(
          onTap: () {
            //OrgUnitSelector orgUnitSelector = Provider.of<OrgUnitSelector>(context, listen: false);
            if (orgUnitSelector.selected.length == 0) {
              // showMessage(context, 'WARNING', 'Select atleast one organisation unit', () {});
              return;
            }
            Navigator.pop(context, orgUnitSelector.selected);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                style: BorderStyle.solid,
                width: 1.0,
              ),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "Select",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class OrganisationUnitParent extends StatefulWidget {
  OrganisationUnit organisationUnit;

  OrganisationUnitParent(this.organisationUnit);

  @override
  _OrganisationUnitParentState createState() => _OrganisationUnitParentState();
}

class _OrganisationUnitParentState extends State<OrganisationUnitParent> {
  bool showChildren = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    OrgUnitSelector orgUnitSelector = Provider.of<OrgUnitSelector>(context);
    Checkbox checkbox = Checkbox(
      value: orgUnitSelector.isSelected(widget.organisationUnit),
      onChanged: (change) {
        if (change as bool) {
          orgUnitSelector.select(widget.organisationUnit);
        } else {
          orgUnitSelector.deselect(widget.organisationUnit);
        }
      },
    );
    Widget noChildrenWidget = Padding(
      padding: const EdgeInsets.only(left: 48.0),
      child: Row(
        children: <Widget>[
          checkbox,
          Flexible(
              child: Container(
                  child: Text(
            widget.organisationUnit.displayName as String,
            overflow: TextOverflow.ellipsis,
          )))
        ],
      ),
    );

    return FutureBuilder<List<OrganisationUnit>>(
        // future: DHIS2.OrganisationUnit.getChildren(widget.organisationUnit.id, level: widget.organisationUnit.level),
        future: OrganisationUnitQuery()
            .where(attribute: "parent", value: widget.organisationUnit.id)
            .get(),
        // D2Touch.organisationUnitModule.organisationUnit
        //     .where(attribute: "parent", value: widget.organisationUnit.id).get(),
        builder: (context, snapshot) {
          // if(!snapshot.hasData) {
          //   return Center(child: CircularProgressIndicator(strokeWidth: 1,),);
          // }

          if (snapshot.hasData) {
            orgUnitSelector.finishedLoading(widget.organisationUnit);

            if (snapshot.data?.length == 0) {
              return noChildrenWidget;
            } else {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      checkbox,
                      IconButton(
                        icon: Icon(showChildren
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right),
                        onPressed: () {
                          setState(() {
                            showChildren = !showChildren;
                          });
                          orgUnitSelector
                              .loadingChildren(widget.organisationUnit);
                        },
                      ),
                      Flexible(
                          child: Container(
                              child: Text(
                        widget.organisationUnit.displayName as String,
                        overflow: TextOverflow.ellipsis,
                      )))
                    ],
                  ),
                  showChildren
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            children: (snapshot.data as List).map((orgUnit) {
                              return OrganisationUnitParent(orgUnit);
                            }).toList(),
                          ),
                        )
                      : SizedBox()
                ],
//              childList: [
//
//              ],
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error -' + snapshot.error.toString());
          } else {
            return noChildrenWidget;
          }
        });
  }
}
