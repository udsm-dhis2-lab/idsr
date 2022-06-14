import 'package:eIDSR/shared/model/app_input_field_result_model.dart';
import 'package:eIDSR/shared/model/option.model.dart';
import 'package:flutter/material.dart';

class AppFieldInput extends StatefulWidget {
  final String valueType;
  final bool? mandatory;
  final String? attributeOptionCombo;
  final String? categoryOptionCombo;
  final String displayName;
  final String fieldId;
  final String? period;
  final String? dataValueSet;
  final bool? showDataWaring;
  final List<DataOption>? options;
  final inputValue;
  final Function(FieldInputResult) onFieldInputChanged;

  AppFieldInput(
      {Key? key,
      // this.field,
      this.inputValue,
      this.mandatory,
      this.options,
      this.attributeOptionCombo,
      this.categoryOptionCombo,
      this.period,
      this.showDataWaring,
      this.dataValueSet,
      required this.fieldId,
      required this.valueType,
      required this.displayName,
      required this.onFieldInputChanged})
      : super(key: key);

  @override
  _FieldInputState createState() => _FieldInputState();
}

class _FieldInputState extends State<AppFieldInput> {
  bool requriedError = false;
  String? dropDownValue;
  final _formKey = GlobalKey<FormState>();
  TextEditingController inputFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.fieldId == 'EyyNpp4BQtT' &&
        widget.categoryOptionCombo == 'uGIJ6IdkP7Q' &&
        widget.inputValue == null) {
      final fieldInputResult = new FieldInputResult(
          value: (widget.period as String) +
              '-' +
              (widget.dataValueSet as String)
                  .split('_' + (widget.period as String))[0],
          fieldid: widget.fieldId,
          categoryOptionCombo: widget.categoryOptionCombo ?? null,
          attributeOptionCombo: widget.attributeOptionCombo ?? null);
      // fieldInputResultFromJson(fieldResult.toString());
      widget.onFieldInputChanged(fieldInputResult);
    }

    inputFieldController = TextEditingController(
        text: widget.fieldId == 'EyyNpp4BQtT' &&
                widget.categoryOptionCombo == 'uGIJ6IdkP7Q' &&
                widget.inputValue == null
            ? (widget.period as String) +
                '-' +
                (widget.dataValueSet as String)
                    .split('_' + (widget.period as String))[0]
            : widget.inputValue ?? null);
  }

  @override
  Widget build(BuildContext context) {
    // print("re rendering input");
    // print(widget.validationRuleActions);

    return Container(
      padding: EdgeInsets.all(15),
      // height: 50,
      child: renderFieldInput(),
    );
  }

  renderFieldInput() {
    if (widget.options?.length == 0 || widget.options == null) {
      return widget.fieldId == 'EyyNpp4BQtT' &&
              widget.categoryOptionCombo == 'uGIJ6IdkP7Q'
          ? Text((widget.period as String) +
              '-' +
              (widget.dataValueSet as String)
                  .split('_' + (widget.period as String))[0])
          : Focus(
              child: TextFormField(
                key: _formKey,
                controller: inputFieldController,
                // controller: TextEditingController(text: widget.inputValue),
                keyboardType: getInputType(),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  // border: OutlineInputBorder(),
                  labelText: getDisplayFormName(),
                  border: UnderlineInputBorder(),
                  // labelText: widget.field['displayName'],
                  errorText: requriedError
                      ? 'Required'
                      : widget.showDataWaring == true
                          ? "Warning! rules violated"
                          : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  // do stuff
                } else {
                  if (inputFieldController.text.toString().isEmpty &&
                      widget.mandatory != null) {
                    setState(() {
                      requriedError = true;
                    });
                  }
                  final fieldInputResult = new FieldInputResult(
                      value: inputFieldController.text,
                      fieldid: widget.fieldId,
                      categoryOptionCombo: widget.categoryOptionCombo ?? null,
                      attributeOptionCombo:
                          widget.attributeOptionCombo ?? null);
                  // fieldInputResultFromJson(fieldResult.toString());
                  widget.onFieldInputChanged(fieldInputResult);
                }
              },
            );
    }

    if (widget.options != null) {
      // check if there is matching data from option
      if ((getOptionsDroptDown() as List).where((element) {
            return element.value.toString() == widget.inputValue.toString();
          }).length ==
          1) {
        return DropdownButtonFormField(
          isExpanded: true,
          // overflow: TextOverflow.ellipsis,
          value: widget.inputValue,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: UnderlineInputBorder(),
            labelText: getDisplayFormName(),
            errorText: requriedError
                ? 'Required'
                : widget.showDataWaring == true
                    ? "Bad data"
                    : null,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          // value: widget.inputValue == null ? '' : widget.inputValue,
          validator: (value) => value == null
              ? 'field required'
              : widget.showDataWaring == true
                  ? "Bad data"
                  : null,
          items: getOptionsDroptDown(),
          onChanged: (value) {
            final fieldInputResult = new FieldInputResult(
                value: value.toString(),
                fieldid: widget.fieldId,
                categoryOptionCombo: widget.categoryOptionCombo ?? null,
                attributeOptionCombo: widget.attributeOptionCombo ?? null);
            widget.onFieldInputChanged(fieldInputResult);
            // widget.onFieldInputChanged(widget.field, value);
          },
          // hint: Text(getDisplayFormName(), overflow: TextOverflow.ellipsis),
          disabledHint: Text("Disabled"),
          elevation: 8,
        );
      } else {
        return DropdownButtonFormField(
          isExpanded: true,

          // overflow: TextOverflow.ellipsis,
          // value: widget.inputValue,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: UnderlineInputBorder(),
            errorText: requriedError
                ? 'Required'
                : widget.showDataWaring == true
                    ? "Bad data"
                    : null,
            labelText: getDisplayFormName(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          // value: widget.inputValue == null ? '' : widget.inputValue,
          validator: (value) => value == null
              ? 'field required'
              : widget.showDataWaring == true
                  ? "Bad data"
                  : null,
          items: getOptionsDroptDown(),
          onChanged: (value) {
            final fieldInputResult = new FieldInputResult(
                value: value.toString(),
                fieldid: widget.fieldId,
                categoryOptionCombo: widget.categoryOptionCombo ?? null,
                attributeOptionCombo: widget.attributeOptionCombo ?? null);
            widget.onFieldInputChanged(fieldInputResult);
            // widget.onFieldInputChanged(widget.field, value);
          },
          // hint: Text(getDisplayFormName(), overflow: TextOverflow.ellipsis),
          disabledHint: Text("Disabled"),
          elevation: 8,
        );
      }
    }
  }

  /* bool shouldWarn(String dataElement, String catOptCombo) {
    if (widget.validationRuleActions == null) {
      return false;
    } else {
      List<ValidationRuleAction> listOfVrules =
          (widget.validationRuleActions as List<ValidationRuleAction>)
              .where((element) =>
                  element.categoryOptionCombo.contains(catOptCombo) &&
                  element.dataElement.contains(dataElement) &&
                  element.warn)
              .toList();

      return listOfVrules.length > 0 ? true : false;
    }
  }
*/
  getDisplayFormName() {
    if (widget.mandatory != null && widget.mandatory == true) {
      return '${widget.displayName} *';
    } else {
      return widget.displayName;
    }
  }

  getInputType() {
    if (widget.valueType == 'TEXT') {
      return TextInputType.text;
    }
    if (widget.valueType == 'INTEGER_POSITIVE' ||
        widget.valueType == 'INTEGER_ZERO_OR_POSITIVE' ||
        widget.valueType == 'NUMBER' ||
        widget.valueType == 'PHONE_NUMBER') {
      return TextInputType.number;
    }
    if (widget.valueType == 'PHONE_NUMBER') {
      return TextInputType.phone;
    }
    return TextInputType.text;
  }

  getOptionsDroptDown() {
    final options =
        (widget.options ?? []).map((DataOption item) => item.name).toList();
    final optionsDropDown = options
        // <String>['One', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((value) {
      return DropdownMenuItem<String>(
        value: value.toString(),
        child: Text(value.toString(), overflow: TextOverflow.ellipsis),
      );
    }).toList();

    return optionsDropDown;
  }
}
