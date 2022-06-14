import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopAppbarWidget extends StatefulWidget {
  const TopAppbarWidget({Key? key}) : super(key: key);

  @override
  _TopAppbarWidgetState createState() => _TopAppbarWidgetState();
}

class _TopAppbarWidgetState extends State<TopAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text("+"),
        title: Text("App bar"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more))],
      ),
    );
  }
}
