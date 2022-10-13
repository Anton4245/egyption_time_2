import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/core/test_meeting.dart';

import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:flutter/foundation.dart';

class Meetings with ChangeNotifier {
  //async is more dangerous, we will try to use no any asyc without significant sense of it
  List<Meeting> _meetingList = TestMeeting.giveAnyListOfMeetings();
  List<Meeting> get meetingList => _meetingList;

  updateMeetingList(newvalue) {
    _meetingList = newvalue;
    sort();
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

  void addNewMeeting() {
    _meetingList.add(Meeting());
    sort();
    provideModifying();
  }

  void sort() {
    _meetingList
        .sort(((a, b) => -a.creationDateTime.compareTo(b.creationDateTime)));
  }

  void changeModel() {
    provideModifying();
  }

  saveAll() {
    GlobalModel.instance.hiveImpl.saveMeetingList();
  }
}
