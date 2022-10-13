import 'dart:io';

import 'package:ejyption_time_2/core/Contacts/contacts_impl_flutter_contacts.dart';
import 'package:ejyption_time_2/core/Contacts/contacts_provider_interface.dart';
import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:hive/hive.dart';

import 'package:ejyption_time_2/core/hive.dart/hive_cipher_impl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class HiveImpl {
  late final BoxCollection collection;
  late final CollectionBox<String> MeetingBox;
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
      'EgyptionTime', // Name of your database
      {
        'Meetings',
        'PointAssestments',
        'ProbabilityAssestments'
      }, // Names of your boxes
      path:
          '${directory.path.toString()}', // Path where to store your boxes (Only used in Flutter / Dart IO)
      // key:
      //     HiveCipherImpl(), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
    );
    MeetingBox = (await collection.openBox<String>('Meetings'));
  }

  Future<void> updateMeetingList() async {
    GlobalModel.instance.meetings.updateMeetingList(
        (await MeetingBox.getAllValues())
            .entries
            .map((e) => Meeting.fromJson(e.value))
            .toList());
  }

  saveMeetingList() async {
    for (var meeting in GlobalModel.instance.meetingList) {
      MeetingBox.put(meeting.id, meeting.toJson());
    }
  }
  // Open your boxes. Optional: Give it a type.

}
