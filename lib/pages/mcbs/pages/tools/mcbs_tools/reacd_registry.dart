import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/shared/widgets/tracker/tracker_program_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReAcdRegister extends TrackerProgramPage {
  ReAcdRegister({Key? key})
      : super(
            key: key,
            programId: "ib6PYHQ5Aa8",
            disableCompleting: false,
            caseListingAttributeParams:
                AppConstants.trackerSummaryListConfigs["ib6PYHQ5Aa8"],
            hideEnrollmentActiveness: true,
            hideAddTrackerButton: true,
            hideEditButton: true,
            hideViewButton: true,
            editStagesOnly: true,
            title: 'Re-ACD Register');
}
