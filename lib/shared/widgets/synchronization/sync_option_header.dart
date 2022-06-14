import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SyncOptionHeader extends StatefulWidget {
  final String title;
  final String info;
  final IconData icon;
  final Color color;

  const SyncOptionHeader(
      {Key? key,
      required this.title,
      required this.icon,
      required this.info,
      required this.color})
      : super(key: key);

  @override
  _SyncOptionHeaderState createState() => _SyncOptionHeaderState();
}

class _SyncOptionHeaderState extends State<SyncOptionHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.only(top: 20, bottom: 20, right: 0, left: 20),
      child: Row(children: [
        Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          padding: EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.color,
                size: 30,
              )
            ],
          ),
        ),
        Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          width: MediaQuery.of(context).size.width*0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              // Wrap(
              //   children: [
              Text(
                widget.info,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: Colors.green),
              ),
              //   ],
              // ),
            ],
          ),
        )
      ]),
    );
  }
}
