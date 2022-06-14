import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataClear extends StatefulWidget {
  const DataClear({Key? key}) : super(key: key);

  @override
  _DataClearState createState() => _DataClearState();
}

class _DataClearState extends State<DataClear> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.error),
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DOWNLOAD METADATA",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        )
                      ]))),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
