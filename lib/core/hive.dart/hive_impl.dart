import 'dart:io';

import 'package:ejyption_time_2/core/contacts/contacts_impl_flutter_contacts.dart';
import 'package:ejyption_time_2/models/global/global_model.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:hive/hive.dart';

//import 'package:ejyption_time_2/core/hive.dart/hive_cipher_impl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class HiveImpl {
  BoxCollection? collection;
  CollectionBox<String>? meetingBox;
  bool permissionDenied = false;
  MyFlutterContacts contactsProviderImpl = MyFlutterContacts();

  HiveImpl() {
    init();
  }

  init() async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      await openAllBoxes();
      updateMeetingList();
    } else {
      permissionDenied = true;
    }
  }

  Future<void> openAllBoxes() async {
    Directory directory = await getApplicationDocumentsDirectory();
    BoxCollection collection = await BoxCollection.open(
      'EgyptionTime',
      {
        'Meetings',
        'PointAssestments',
        'ProbabilityAssestments'
      }, // Names of your boxes
      path: directory.path.toString(),
      // key:
      //     HiveCipherImpl(), // toDo: enctiprion
    );
    meetingBox = (await collection.openBox<String>('Meetings'));
  }

  Future<void> updateMeetingList() async {
    if (meetingBox == null) {
      return;
    }
    List<Meeting> retrievedMettings = await retrieveAllMeetings();
    GlobalModel.instance.meetings.updateMeetingList(retrievedMettings, false);
  }

  retrieveAllMeetings() async {
    return meetingBox!.getAllValues().then((rawMap) =>
        rawMap.entries.map((e) => Meeting.fromJson(e.value)).toList());
  }

  saveMeetingList() async {
    for (var meeting in GlobalModel.instance.meetingList) {
      meetingBox?.put(meeting.id, meeting.toJson());
    }
  }

  Future<void> remove(id) async {
    meetingBox?.delete(id);
  }
}
