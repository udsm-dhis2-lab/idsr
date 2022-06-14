import 'dart:ffi';

import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/data/aggregate/entities/data_value.entity.dart';
import 'package:d2_touch/modules/data/aggregate/entities/data_value_set.entity.dart';
import 'package:d2_touch/modules/engine/validation_rule/models/validation_rule_action.model.dart';
import 'package:d2_touch/modules/engine/validation_rule/models/validation_rule_result.model.dart';
import 'package:d2_touch/modules/engine/validation_rule/validation_rule_engine.dart';
import 'package:eIDSR/shared/model/aggregate_form_section_model.dart';
import 'package:eIDSR/shared/model/app_input_field_result_model.dart';
import 'package:eIDSR/shared/model/custom_dataelement_model.dart';
import 'package:eIDSR/shared/model/vrule.model.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:eIDSR/shared/model/trackerFromSection_model.dart';
import 'package:eIDSR/shared/widgets/form/app_field_input.dart';

class AggregateFormCardSection extends StatefulWidget {
  AggregateFormSection formSection;
  DataValueSet? dataValueSet;
  String datasetId;
  List<CustomDataElement> datasetDataElements;

  AggregateFormCardSection(
      {Key? key,
      required this.formSection,
      this.dataValueSet,
      required this.datasetId,
      required this.datasetDataElements})
      : super(key: key);

  @override
  _AggregateFormCardSectionState createState() =>
      _AggregateFormCardSectionState();
}

class _AggregateFormCardSectionState extends State<AggregateFormCardSection> {
  List<String> elementToWarn = [];

  @override
  void initState() {
    super.initState();

    initialValidationRule();
  }

  initialValidationRule() async {
    ValidationRuleResult validationRuleResult =
        await ValidationRuleEngine.execute(
      dataValueSet: widget.dataValueSet as DataValueSet,
      dataSet: widget.dataValueSet?.dataSet as String,
    );

    List<String> dataElements = [];
    validationRuleResult.validationRuleActions
        .forEach((ValidationRuleAction e) {
      dataElements.addAll(e.dataElements);
    });

    setState(() {
      elementToWarn = dataElements;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("rebuilding");

    return Card(
      child: ClipPath(
        child: Container(
          // height: 100,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: AppColors.blueThemeColor, width: 5))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.formSection.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.blueThemeColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: loadFormGroups(),
                ),
              )
            ],
          ),
        ),
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      ),
      // child: Row(
      //   children: [
      //     Flexible(
      //         flex: 1,
      //         child: SizedBox(child: Container(color: Colors.blueAccent))),
      //     Column(
      //       children: [
      //         Column(
      //           children: [Text('Hello')],
      //         )
      //       ],
      //     )
      //   ],
      // ),
    );
  }

  loadFormGroups() {
    // print("reloading form groups");

    final formGroups = widget.formSection.fieldGroups.map<Widget>(
      (fieldGroup) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldGroup.category == 'ReportID'
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Text(fieldGroup.category + '*'),
                  ),
            ...loadFromCategories(fieldGroup.categoryOptionCombos),
          ],
        );
      },
    ).toList();
    return formGroups;
  }

  loadFromCategories(List<CategoryOptionCombo> categoryOptionCombos) {
    // print("reloading form categories");
    final formCatOptionCombo = categoryOptionCombos
        .map<Widget>((catOptCombo) => catOptCombo.isFormHorizontal == true
            ? Row(
                children: catOptCombo.fields
                    .map<Widget>((field) => Flexible(
                          child: AppFieldInput(
                              // field: field,
                              displayName: field.displayName,
                              showDataWaring: showDataWarning(
                                  widget.formSection.dataElement,
                                  field.categoryOptionCombo),
                              inputValue: getInputValue(
                                  widget.formSection.dataElement,
                                  field.categoryOptionCombo),
                              period: widget.dataValueSet?.period,
                              dataValueSet: widget.dataValueSet?.id,
                              mandatory: false,
                              categoryOptionCombo: field.categoryOptionCombo,
                              fieldId: widget.formSection.dataElement,
                              valueType: getFieldValueType(
                                  widget.formSection.dataElement),
                              onFieldInputChanged:
                                  (FieldInputResult fieldResult) {
                                saveDataElement(fieldResult);
                              }),
                        ))
                    .toList(),
              )
            : Column(
                children: catOptCombo.fields
                    .map<Widget>((field) => Flexible(
                        child: AppFieldInput(
                            // field: field,
                            inputValue: getInputValue(
                                widget.formSection.dataElement,
                                field.categoryOptionCombo),
                            period: widget.dataValueSet?.period,
                            dataValueSet: widget.dataValueSet?.id,
                            displayName: field.displayName,
                            showDataWaring: showDataWarning(
                                widget.formSection.dataElement,
                                field.categoryOptionCombo),
                            mandatory: false,
                            categoryOptionCombo: field.categoryOptionCombo,
                            fieldId: widget.formSection.dataElement,
                            valueType: getFieldValueType(
                                widget.formSection.dataElement),
                            onFieldInputChanged:
                                (FieldInputResult fieldResult) {
                              saveDataElement(fieldResult);
                            })))
                    .toList(),
              ))
        .toList();
    return formCatOptionCombo;
  }

  saveDataElement(FieldInputResult fieldInputResult) async {
    // print(" i get called ");

    if (widget.dataValueSet?.synced == true) {
      widget.dataValueSet?.synced = false;
      widget.dataValueSet?.dirty = true;

      await D2Touch.aggregateModule.dataValueSet
          .setData(widget.dataValueSet)
          .save();
    }

    DataValue dataValue = new DataValue(
        id:
            '${widget.dataValueSet?.id}-${fieldInputResult.fieldid}-${fieldInputResult.categoryOptionCombo != null ? fieldInputResult.categoryOptionCombo as String : ""}',
        name:
            '${widget.dataValueSet?.id}-${fieldInputResult.fieldid}-${fieldInputResult.categoryOptionCombo != null ? fieldInputResult.categoryOptionCombo as String : ""}',
        dataElement: fieldInputResult.fieldid,
        attributeOptionCombo: fieldInputResult.attributeOptionCombo,
        categoryOptionCombo: fieldInputResult.categoryOptionCombo != null
            ? fieldInputResult.categoryOptionCombo as String
            : '',
        dataValueSet: widget.dataValueSet?.id,
        value: fieldInputResult.value,
        synced: false,
        dirty: false);

    await D2Touch.aggregateModule.dataValue.setData(dataValue).save();

    DataValue savedDataValue = await D2Touch.aggregateModule.dataValue
        .byId(
            '${widget.dataValueSet?.id}-${fieldInputResult.fieldid}-${fieldInputResult.categoryOptionCombo != null ? fieldInputResult.categoryOptionCombo as String : ""}')
        .getOne();
    print('nnafika');
    print(widget.datasetId);
    ValidationRuleResult validationRuleResult =
        await ValidationRuleEngine.execute(
            dataValueSet: widget.dataValueSet as DataValueSet,
            dataSet: widget.dataValueSet?.dataSet as String,
            changedDataValue: savedDataValue);

    List<String> dataElements = [];
    validationRuleResult.validationRuleActions
        .forEach((ValidationRuleAction e) {
      dataElements.addAll(e.dataElements);
    });

    setState(() {
      elementToWarn = dataElements;
    });

    print("validation actions");
    print(validationRuleResult.validationRuleActions.length);
    validationRuleResult.validationRuleActions.forEach((element) {
      print("action : " + element.action);
      print("elems");
      print(element.dataElements);
    });
  }

  bool showDataWarning(String dataElement, String categoryOptionCombo) {
    if (elementToWarn.length < 1) {
      return false;
    } else {
      var matchedElementsToWarn = elementToWarn.where(
          (element) => dataElement + '.' + categoryOptionCombo == element);

      return matchedElementsToWarn.length > 0 ? true : false;
    }
  }

  getFieldValueType(String fieldId) {
    List<CustomDataElement> customDE = widget.datasetDataElements
        .where((CustomDataElement de) => de.id == fieldId)
        .toList();
    return customDE.length > 0 ? customDE[0].valueType : 'TEXT';
  }

  getInputValue(
    String dataElement,
    String categoryOptionCombo,
  ) {
    List<DataValue>? matchedDataValues = (widget.dataValueSet as DataValueSet)
        .dataValues
        ?.where((DataValue dataValue) {
      return dataValue.dataElement == dataElement &&
          ((categoryOptionCombo != null &&
                  dataValue.categoryOptionCombo == categoryOptionCombo) ||
              categoryOptionCombo == null);
    }).toList();

    if (matchedDataValues != null && matchedDataValues.length > 0) {
      return matchedDataValues[0].value;
    }

    return null;
  }
}
