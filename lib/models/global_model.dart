import 'package:ejyption_time_2/core/crypto/cripto_interface.dart';
import 'package:ejyption_time_2/core/crypto/crypto_dart_dev_impl.dart';
import 'package:ejyption_time_2/core/hive.dart/hive_impl.dart';
import 'package:ejyption_time_2/ui/features/list_of_meeting/meeting_list_provider.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/test_meeting.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:ejyption_time_2/models/participants/participant.dart';
import 'package:flutter/material.dart';

class GlobalModel {
  //Singleton constractor
  GlobalModel._privateConstructor();
  static final GlobalModel instance = GlobalModel._privateConstructor();

  Meeting meeting = TestMeeting.giveAnyTestMeeting();
  Meetings meetings = Meetings();
  List<Meeting> get meetingList => meetings.meetingList;
  HiveImpl hiveImpl = HiveImpl();

  final modifiedObjects = ModifiedObjects();
  final Participant? currentParticipant = Participant(
          myContact: MyContact(
              id: 'kadsgladfkadyqiqasd',
              name: 'Anton',
              displayName: 'Anton Victorovich'))
      .setIsInitiator(true);

  final areaCode = '+7343';
  final localPhoneLength = 7;
  final countryCode = '+7';
  final mobilPhoneSignificantLength = 10;
  BuildContext? commonContext;

  CryptoInterface cryptoImpl = CryptoDartDevImpl();
  String myContactsPassword = 'akjhfnqucakjs623fkalb92jlaoash';
}
