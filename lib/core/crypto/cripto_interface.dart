import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:flutter/cupertino.dart';

abstract class CryptoInterface {
  String convertStringWithPassword(String intString, String intPassword);

  String getPasswordByContact(Meeting meeting, MyContact myContact) {
    return meeting.contactsUniqueKey
        .putIfAbsent(myContact.id, () => UniqueKey().toString());
  }

  String convertStringWithContactsUniqueKey(
      String intString, Meeting meeting, MyContact myContact) {
    return convertStringWithPassword(
        intString, getPasswordByContact(meeting, myContact));
  }
}
