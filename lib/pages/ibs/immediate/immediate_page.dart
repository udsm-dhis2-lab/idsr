import 'package:eIDSR/shared/widgets/tracker/tracker_program_page.dart';
import 'package:flutter/material.dart';
import 'package:eIDSR/constants/constants.dart';

class ImmediateProgramPage extends TrackerProgramPage {
  ImmediateProgramPage({Key? key})
      : super(
            key: key,
            disableCompleting: false,
            programId: AppConstants.immediateProgramUid,
            trackerformSection: AppConstants.immediateCaseFormSection,
            caseListingAttributeParams: AppConstants.immediateCaseListingParams,
            title: 'Immediate');
}
