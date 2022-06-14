import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String path;

  const CardWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.path})
      : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              width: 30,
              child: Text("Img"),
            ),
            Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  widget.description,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ],
            )
          ],
        ));
  }
}
