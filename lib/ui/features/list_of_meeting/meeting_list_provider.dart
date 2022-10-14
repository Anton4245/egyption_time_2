import 'package:ejyption_time_2/models/global_model.dart';
import 'package:ejyption_time_2/models/test_meeting.dart';

import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:flutter/foundation.dart';

class Meetings with ChangeNotifier {
  //async is more dangerous, we will try to use no any asyc without significant sense of it
  List<Meeting> _meetingList = TestMeeting.giveAnyListOfMeetings();
  List<Meeting> get meetingList => _meetingList;
  bool listIsUpdating = true;
  Function? actionToDo;

  updateMeetingList(newvalue, [bool modify = true]) {
    _meetingList = newvalue;
    sort();
    listIsUpdating = false;
    if (modify) {
      provideModifying();
    }
  }

  int _version = 0;
  int get version => _version;

  void provideModifying([bool notify = true]) {
    _version++;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> activateUpdateAction() async {
    actionToDo?.call();
  }

  void addNewMeeting() {
    _meetingList.add(Meeting());
    sort();
    provideModifying();
  }

  void sort() {
    _meetingList
        .sort(((a, b) => -a.creationDateTime.compareTo(b.creationDateTime)));
  }

  void delete(id) {
    meetingList.removeWhere((element) => element.id == id);
    Future.delayed(const Duration(seconds: 1), () {
      GlobalModel.instance.hiveImpl
          .remove(id)
          .then((value) => GlobalModel.instance.meetings.listIsUpdating = false)
          .then((value) => provideModifying());
    });
  }

  void deleteWithPause(String id) {
    listIsUpdating = true;
    actionToDo = () {
      delete(id);
    };
    provideModifying();
  }

  void changeModel() {
    provideModifying();
  }

  saveAll() {
    GlobalModel.instance.hiveImpl.saveMeetingList();
  }
}
