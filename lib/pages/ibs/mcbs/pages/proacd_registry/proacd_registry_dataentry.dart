import 'package:d2_touch/modules/data/tracker/entities/event.entity.dart';
import 'package:d2_touch/modules/data/tracker/entities/tracked-entity.entity.dart';
import 'package:eIDSR/shared/modules/Events/pages/event_form.dart';
import 'package:flutter/cupertino.dart';

class ProACDDataEntry extends EventForm {
  Event event;

  ProACDDataEntry({Key? key, required this.event})
      : super(
            key: key,
            stageUuid: "PXsALJ60dF3",
            programId: "A3olldDSHQg",
            event: event,
            title: "Pro-ACD Data Entry");
}
