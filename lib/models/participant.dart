import 'dart:typed_data';

import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:flutter/material.dart';

class Participant {
  GlobalKey id = GlobalKey();
  String contactId = '';
  List<String> phones = [];
  List<String> phoneNumbershash = [];
  String name;
  String displayName;
  String initials;
  Uint8List? photoOrThumbnail;
  bool _isInitiator = false;
  bool get isInitiator => _isInitiator;
  Participant setIsInitiator(bool isInitiator) {
    _isInitiator = isInitiator;
    return this;
  }

  Participant({
    required this.name,
    required this.displayName,
    this.initials = '',
  }) {
    if (initials == '') {
      (name.isNotEmpty ? name : displayName).split(' ').forEach((element) {
        initials +=
            element.isNotEmpty ? element.substring(0, 1).toUpperCase() : '';
        if (initials.length > 2) {
          initials = initials.substring(0, 1) +
              initials.substring(initials.length - 1, initials.length);
        }
      });
    }
  }

  factory Participant.fromMyContact(MyContact myContact) {
    Participant newParticipant =
        Participant(name: myContact.name, displayName: myContact.displayName);
    newParticipant.contactId = myContact.id;
    newParticipant.phones.addAll(myContact.phones);
    newParticipant.photoOrThumbnail = myContact.photoOrThumbnail;
    return newParticipant;
  }
}
