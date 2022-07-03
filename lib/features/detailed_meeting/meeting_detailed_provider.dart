import 'package:ejyption_time_2/core/common_widgets/new_assessment.dart';
import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/features/contacts/participants_selection_provider.dart';
import 'package:ejyption_time_2/features/detailed_meeting/constant_field_provider.dart';
import 'package:ejyption_time_2/models/participant.dart';
import 'package:ejyption_time_2/models/probability_assesstment.dart';
import '../../models/meeting.dart';
import 'package:flutter/widgets.dart';

enum MainMenu {
  changeFinallyNegotiated,
  setProbabilityAssessment,
  deleteProbabilityAssessment
}

enum ParticipantsMenu { modifyParticipants, viewParticipants }

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

  List<MainMenu> createMainMenuList(
      ProbabilityAssessment? probabilityAssessment) {
    List<MainMenu> m = <MainMenu>[];

    if (GlobalModel.instance.currentParticipant?.isInitiator ?? false) {
      m.add(MainMenu.changeFinallyNegotiated);
    }
    m.add(MainMenu.setProbabilityAssessment);
    if (probabilityAssessment != null) {
      m.add(MainMenu.deleteProbabilityAssessment);
    }

    return m;
  }

  void mainMenuOnSelected(MainMenu menuItem) {
    if (menuItem == MainMenu.changeFinallyNegotiated) {
      meeting.setFinallyNegotiated(!meeting.finallyNegotiated);
    }
  }

  void participantsMenuOnSelected(ParticipantsMenu menuItem) {
    if ((menuItem == ParticipantsMenu.modifyParticipants) ||
        (menuItem == ParticipantsMenu.viewParticipants)) {
      if (!meeting.participants.isModifying) {
        meeting.participants.isModifying = true;
        meeting.participants.modifyingFormProvider =
            ParticipantsSelectionProvider(meeting.participants,
                (menuItem == ParticipantsMenu.modifyParticipants));
      } else if ((menuItem == ParticipantsMenu.modifyParticipants) &&
          (meeting.participants.modifyingFormProvider
                      as ParticipantsSelectionProvider)
                  .modifyParticipants ==
              false) {
        meeting.participants.modifyingFormProvider =
            ParticipantsSelectionProvider(meeting.participants,
                (menuItem == ParticipantsMenu.modifyParticipants));
      }
    }
  }

  processResultOfNewAssesment(
      bool result, Map<ProbabilityValues, Object?> values) {
    if (result) {
      ProbabilityAssessment newAssesstment = ProbabilityAssessment(
          participant: GlobalModel.instance.currentParticipant ??
              Participant(name: 'Incognito', displayName: 'Incognito'),
          meetingId: meeting.id,
          mark: values[ProbabilityValues.mark] as ProbabilityMarks,
          assessmentText: values[ProbabilityValues.text] as String,
          probability: values[ProbabilityValues.probability] as int);

      meeting.addPointAssesstment(newAssesstment);
    }
  }

  deleteAssessment() {
    meeting.removePointAssesstment();
  }
}
