import 'package:ejyption_time_2/core/crypto/cripto_interface.dart';
import 'package:ejyption_time_2/core/crypto/crypto_dart_dev_impl.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/core/test_meeting.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:ejyption_time_2/models/participant.dart';
import 'package:flutter/material.dart';

class GlobalModel {
  //Singleton constractor
  GlobalModel._privateConstructor();
  static final GlobalModel instance = GlobalModel._privateConstructor();

  Meeting meeting = TestMeeting.giveAnyTestMeeting();
  List<Meeting> meetingList = TestMeeting.giveAnyListOfMeetings();
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
