import 'package:flutter/material.dart';
import 'package:eIDSR/misc/colors.dart';

class UserWelcomeCard extends StatelessWidget {
  final String header;
  final String description;
  UserWelcomeCard({Key? key, required this.header, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fadeGreen,
      ),
      padding: EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.header,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10,
          ),
          Text(this.description,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textMuted)),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
