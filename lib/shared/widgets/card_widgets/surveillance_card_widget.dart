import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';

class SurveillanceCard extends StatelessWidget {
  final String header;
  final String description;
  final String icon;
  final String routePath;
  final double width;

  SurveillanceCard({Key? key,
    required this.header,
    required this.width,
    required this.description,
    required this.icon,
    required this.routePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/' + this.routePath);
      },
      child: Container(
        // height: 130,
        width: width,
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Image.asset(
                'images/' + this.icon,
                width: 64,
                // height: 40,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.8) - 104 ,
                    child: Text(
                      this.header,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.8) - 104 ,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      this.description,
                      style:
                      TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
