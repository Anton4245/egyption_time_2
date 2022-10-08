import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/participant.dart';

abstract class WithIdAndCreationAndParticipant {
  DateTime get creation;
  Participant get participant;
  String get id;
}

void deleteListMembersWithTheSameParticipantAndLowerDate(
    List<WithIdAndCreationAndParticipant> list) {
  try {
    list.removeWhere((element) => list.any((element2) =>
        (element2.participant == element2.participant) &&
        (element.creation.compareTo(element2.creation) < 0)));
  } catch (e) {//nothing to do}
}

WithIdAndCreationAndParticipant? lastAssessment(
    List<WithIdAndCreationAndParticipant> list) {
  List<WithIdAndCreationAndParticipant> tempList = [...list];
  tempList.removeWhere((element) =>
      element.participant != GlobalModel.instance.currentParticipant);

  deleteListMembersWithTheSameParticipantAndLowerDate(tempList);
  return (tempList.length == 1) ? tempList[0] : null;
}

void deleteLastListMember(List<WithIdAndCreationAndParticipant> list) {
  //1. find needed comment
  WithIdAndCreationAndParticipant? last = lastAssessment(list);
  //delete it
  if (last != null) {
    list.removeWhere((element) =>
        (element.id == last.id) &&
        (element.participant == GlobalModel.instance.currentParticipant));
  }
}
