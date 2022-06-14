import 'package:flutter/material.dart';

class ToolsCard extends StatelessWidget {
  final String image;
  final String toolName;
  final String routePath;
  final IconData? icon;
  final String? toolDescription;

  const ToolsCard(
      {Key? key,
      this.toolDescription: null,
      this.icon: null,
      required this.image,
      required this.toolName,
      required this.routePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.routePath.length > 0
            ? Navigator.pushNamed(context, '/' + this.routePath)
            : () {};
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon == null
                    ? Image.asset(
                        'images/' + this.image,
                        width: MediaQuery.of(context).size.width * 0.43,
                      )
                    : Container(
                        // width: 150,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(this.icon as IconData)]),
                      ),
              ],
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(top: 3, bottom: 10),
              child: Text(
                this.toolName,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
