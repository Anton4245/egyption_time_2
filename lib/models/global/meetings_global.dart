import 'package:ejyption_time_2/core/firebase_filestore/firebase_filesore.dart';
import 'package:ejyption_time_2/models/global/global_model.dart';
import 'package:ejyption_time_2/models/global/test_meeting.dart';

import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:flutter/foundation.dart';

class Meetings with ChangeNotifier {
  //async is more dangerous, we will try to use no any asyc without significant sense of it
  List<Meeting> _meetingList = TestMeeting.giveAnyListOfMeetings();
  List<Meeting> get meetingList => _meetingList;
  bool listIsUpdating = true;
  Function? actionToDo;

  updateMeetingList(List<Meeting> newList) {
    _meetingList = newList;
    sort();
    listIsUpdating = false;
    provideModifying();
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
    Future.delayed(const Duration(milliseconds: 500), () {
      GlobalModel.instance.hiveImpl.remove(id).then((value) {
        Meeting meeting = meetingList.firstWhere(
          (element) => element.id == id,
          orElse: () => Meeting(),
        );
        meetingList.removeWhere((element) => element.id == id);
        meeting.dispose();
        GlobalModel.instance.meetings.listIsUpdating = false;
        provideModifying();
      });
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

  void shareUpdaits() {
    FirebaseFilestore.instance
        .shareUpdaits()
        .then((result) => result
            ? {
                for (var meeting in _meetingList) {meeting.setShared()}
              }
            : {})
        .then((value) => provideModifying());
    saveAll();
  }
}
