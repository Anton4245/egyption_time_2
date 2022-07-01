import 'package:ejyption_time_2/features/contacts/participants_selection_provider.dart';
import 'package:ejyption_time_2/features/detailed_meeting/constant_field_provider.dart';
import '../../models/meeting.dart';
import 'package:flutter/widgets.dart';

enum MainMenu {
  changeFinallyNegotiated,
}

enum ParticipantsMenu {
  modifyParticipants,
}

class MeetingDetailedProvider with ChangeNotifier {
  final Meeting meeting;
  MeetingDetailedProvider(
    this.meeting,
  ) {
    meeting.addListener(listener);
  }

  listener() {
    notifyListeners();
  }

  @override
  dispose() {
    meeting.removeListener(listener);
    super.dispose();
  }

  ConstantFieldProvider createConstantFieldProvider(field) {
    return ConstantFieldProvider(field: field);
  }

  void mainMenuOnSelected(MainMenu menuItem) {
    if (menuItem == MainMenu.changeFinallyNegotiated) {
      meeting.setFinallyNegotiated(!meeting.finallyNegotiated);
    }
  }

  void participantsMenuOnSelected(ParticipantsMenu menuItem) {
    if (menuItem == ParticipantsMenu.modifyParticipants) {
      if (!meeting.participants.isModifying) {
        meeting.participants.isModifying = true;
        meeting.participants.modifyingFormProvider =
            ParticipantsSelectionProvider(meeting.participants);
      }
    }
  }
}
