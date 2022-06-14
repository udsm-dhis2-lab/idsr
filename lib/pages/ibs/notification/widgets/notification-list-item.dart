import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationListItemWidget extends StatefulWidget {
  final String notificationTypeInitial;
  final String notificationType;
  final String notificationMessage;
  final String notificationTime;
  final bool notificationRead;

  const NotificationListItemWidget(
      {Key? key,
      required this.notificationMessage,
      required this.notificationType,
      required this.notificationTypeInitial,
      required this.notificationTime,
      required this.notificationRead})
      : super(key: key);

  @override
  _NotificationListItemWidgetState createState() =>
      _NotificationListItemWidgetState();
}

class _NotificationListItemWidgetState
    extends State<NotificationListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                  style: BorderStyle.solid))),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.black12,
                    ),
                    child: Center(
                      child: Text(
                        widget.notificationTypeInitial,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: widget.notificationRead
                              ? FontWeight.w300
                              : FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.notificationType,
                          style: TextStyle(
                            fontWeight: widget.notificationRead
                                ? FontWeight.w300
                                : FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.notificationTime,
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.notificationMessage,
                      style: TextStyle(
                        fontWeight: widget.notificationRead
                            ? FontWeight.w300
                            : FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
