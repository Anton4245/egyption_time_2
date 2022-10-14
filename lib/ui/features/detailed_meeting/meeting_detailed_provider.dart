import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/ui/common_widgets/new_assessment.dart';
import 'package:ejyption_time_2/models/global_model.dart';
import 'package:ejyption_time_2/ui/features/contacts/participants_selection_provider.dart';
import 'package:ejyption_time_2/ui/features/detailed_meeting/constant_field_provider.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:ejyption_time_2/models/participants/participant.dart';
import 'package:ejyption_time_2/models/probability_assesstment.dart';
import 'package:flutter/widgets.dart';

enum MainMenu {
  changeFinallyNegotiated,
  setProbabilityAssessment,
  deleteProbabilityAssessment,
  editName,
  testSave,
  deleteMeeting
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
    if (!meeting.finallyNegotiated) {
      m.add(MainMenu.editName);
    }
    m.add(MainMenu.testSave);
    if (GlobalModel.instance.currentParticipant?.isInitiator ?? false) {
      m.add(MainMenu.deleteMeeting);
    }
    return m;
  }

  void mainMenuOnSelected(MainMenu menuItem, [String? textParam]) {
    if (menuItem == MainMenu.changeFinallyNegotiated) {
      meeting.setFinallyNegotiated(!meeting.finallyNegotiated);
    } else if (menuItem == MainMenu.deleteProbabilityAssessment) {
      meeting.removePointAssesstment();
    } else if (menuItem == MainMenu.testSave) {
      // String res = meeting.toJson();
      // //print(res);
      // print(res.hashCode.toString());
      // Meeting newMeeting = Meeting.fromJson(res);
      // String res2 = newMeeting.toJson();
      // //print(res2);
      // print(res2.hashCode.toString());
      // print(res2.hashCode == res.hashCode);
      GlobalModel.instance.meetings.saveAll();
    } else if (menuItem == MainMenu.editName) {
      textParam == null ? {} : meeting.setName(textParam);
    } else if (menuItem == MainMenu.deleteMeeting) {
      GlobalModel.instance.meetings.deleteWithPause(meeting.id);
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
              Participant(
                  myContact: MyContact(
                      id: 'Incognito',
                      name: 'Incognito',
                      displayName: 'Incognito')),
          meetingId: meeting.id,
          mark: values[ProbabilityValues.mark] as ProbabilityMarks,
          assessmentText: values[ProbabilityValues.text] as String,
          probability: values[ProbabilityValues.probability] as int);

      meeting.addPointAssesstment(newAssesstment);
    }
  }
}
