import 'package:eIDSR/constants/constants.dart';
import 'package:eIDSR/shared/widgets/tracker/tracker_program_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MalariaRegistry extends TrackerProgramPage {
  MalariaRegistry({Key? key})
      : super(
            key: key,
            disableCompleting: true,
            programId: AppConstants.malariaRegisrtyProgramUid,
            trackerformSection: AppConstants.mcbsFormSection,
            caseListingAttributeParams:
                AppConstants.trackerSummaryListConfigs["ib6PYHQ5Aa8"],
            title: 'mCBS');
}
