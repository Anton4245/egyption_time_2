import 'dart:math';

import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:flutter/material.dart';

class Participant {
  String id = GlobalKey().toString();
  //String contactId = '';
  List<String> phonesEncripted = [];
  //List<String> phoneNumbershash = [];
  //String name;
  //String displayName;
  String initials;
  //Uint8List? photoOrThumbnail;
  MyContact? myContact;

  bool _isInitiator = false;
  bool get isInitiator => _isInitiator;
  Participant setIsInitiator(bool isInitiator) {
    _isInitiator = isInitiator;
    return this;
  }

  Participant({
    this.myContact,
    this.initials = '',
  }) {
    if ((initials == '') && (myContact != null)) {
      (myContact!.name.isNotEmpty ? myContact!.name : myContact!.displayName)
          .split(' ')
          .forEach((element) {
        initials +=
            element.isNotEmpty ? element.substring(0, 1).toUpperCase() : '';
        if (initials.length > 2) {
          initials = initials.substring(0, 1) +
              initials.substring(initials.length - 1, initials.length);
        }
      });
    }
  }

  factory Participant.fromMyContact(Meeting meeting, MyContact myContact) {
    Participant newParticipant = Participant(myContact: myContact);
    newParticipant.phonesEncripted.addAll(myContact.phones.map((number) {
      return GlobalModel.instance.cryptoImpl.convertStringWithPassword(
          fullNumber(number), meeting.myPersonalContactsUniqueKey);
    }).where((element) => element.isNotEmpty));
    newParticipant.phonesEncripted
        .sort(((a, b) => -a.length.compareTo(b.length)));
    return newParticipant;
  }
}

String fullNumber(String number) {
  //if the number is already full and is in local country
  if ((number.length >= 10) &&
      (number.substring(0, min(1, number.length))) == '+') {
    return number;
  }

  if ((number.length == GlobalModel.instance.mobilPhoneSignificantLength) ||
      (number.length == GlobalModel.instance.mobilPhoneSignificantLength + 1)) {
    return GlobalModel.instance.countryCode +
        number.substring(0, GlobalModel.instance.mobilPhoneSignificantLength);
  }

  if (number.length == GlobalModel.instance.localPhoneLength) {
    return GlobalModel.instance.areaCode + number;
  }

  return '';
}
