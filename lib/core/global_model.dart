import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/core/test_meeting.dart';

class GlobalModel {
  //Singleton constractor
  GlobalModel._privateConstructor();
  static final GlobalModel instance = GlobalModel._privateConstructor();

  Meeting meeting = TestMeeting.giveAnyTestMeeting();
  List<Meeting> meetingList = TestMeeting.giveAnyListOfMeetings();
  final modifiedObjects = ModifiedObjects();
}
