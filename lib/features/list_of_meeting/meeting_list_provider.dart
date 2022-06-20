import 'package:flutter/cupertino.dart';

import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/meeting.dart';

class Meetings with ChangeNotifier {
  //async is more dangerous, we will try to use no any asyc without significant sense of it
  List<Meeting> meetingList = GlobalModel.instance.meetingList;
  Meetings(this.meetingList);

  void changeModel() {
    notifyListeners();
  }
}
