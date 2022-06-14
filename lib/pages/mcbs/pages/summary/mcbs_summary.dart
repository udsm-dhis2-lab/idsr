import 'package:eIDSR/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:eIDSR/misc/colors.dart';
import 'package:flutter/material.dart';

class McbsSummary extends StatefulWidget {
  const McbsSummary({Key? key}) : super(key: key);

  @override
  _McbsSummaryState createState() => _McbsSummaryState();
}

class _McbsSummaryState extends State<McbsSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.2, left: 15, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                color: AppColors.textPrimary,
                size: 30,
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Page Under Construction",
                style: TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        // Create the SelectionScreen in the next step.
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text("Back to Home Page")),
              )
            ],
          )
        ],
      ),
    );
  }
}
