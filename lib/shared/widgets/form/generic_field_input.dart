import 'package:eIDSR/shared/model/option.model.dart';
import 'package:flutter/material.dart';

class GenericFieldInput extends StatefulWidget {
  final String valueType;
  final bool? mandatory;
  final String displayName;
  final String field;
  final inputValue;
  final List<DataOption> options;

  final Function(String, dynamic) onFieldInputChanged;

  GenericFieldInput(
      {Key? key,
      required this.displayName,
      required this.valueType,
      required this.field,
      this.inputValue,
      this.mandatory: false,
      this.options: const [],
      required this.onFieldInputChanged})
      : super(key: key);

  @override
  _FieldInputState createState() => _FieldInputState();
}

class _FieldInputState extends State<GenericFieldInput> {
  bool requriedError = false;
  String? dropDownValue;
  final _formKey = GlobalKey<FormState>();
  TextEditingController inputFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputFieldController =
        TextEditingController(text: widget.inputValue ?? null);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(15),
      child: renderFieldInput(),
    );
  }

  renderFieldInput() {
    if (widget.options.length == 0) {
      return Focus(
        child: TextFormField(
          key: _formKey,
          controller: inputFieldController,
          // controller: TextEditingController(text: widget.inputValue),
          keyboardType: getInputType(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: getDisplayFormName(),
            // labelText: widget.field['displayName'],
            errorText: requriedError ? 'Required' : null,
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
                widget.mandatory as bool) {
              setState(() {
                requriedError = true;
              });
            }
            // capture the changes on input field
            // emit changes outside the widget
            widget.onFieldInputChanged(widget.field, inputFieldController.text);
          }
        },
      );
    }


    if (widget.options.length > 0) {
      return DropdownButtonFormField(
        isExpanded: true,
        // overflow: TextOverflow.ellipsis,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          errorText: requriedError ? 'Required' : null,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        // value: widget.inputValue ?? null,
        validator: (value) => value == null ? 'field required' : null,
        items: getOptionsDroptDown(),
        onChanged: (value) {
          // emit changes outside the widget
          widget.onFieldInputChanged(widget.field, value);
        },
        hint: Text(getDisplayFormName(), overflow: TextOverflow.ellipsis),
        disabledHint: Text("Disabled"),
        elevation: 8,
      );
    }
  }

  getDisplayFormName() {
    if (widget.mandatory as bool) {
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
        (widget.options).map((DataOption item) => item.name).toList();
    final optionsDropDown = options
        // <String>['One', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value.toString(), overflow: TextOverflow.ellipsis),
      );
    }).toList();
    return optionsDropDown;
  }
}
