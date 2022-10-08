import 'package:ejyption_time_2/core/Contacts/contacts_provider_interface.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MyFlutterContacts implements ContactsProviderInterface {
  @override
  Future<List<MyContact>> getContacts() async {
    try {
      List<Contact> contactList = await FlutterContacts.getContacts(
          withProperties: true, withThumbnail: true);
      List<MyContact> myContactList =
          contactList.map((contact) => contactToMyContact(contact)).toList();
      return myContactList;
    } catch (e) {
      return <MyContact>[];
    }
  }

  @override
  Future<bool> requestPermission({bool readonly = false}) {
    return FlutterContacts.requestPermission(readonly: readonly);
  }

  @override
  static void addListener(void Function() listener) {
    FlutterContacts.addListener(listener);
  }

  MyContact contactToMyContact(Contact contact) {
    String name = [
      contact.name.first,
      contact.name.middle,
      contact.name.last
    ].fold(
        '',
        (previousValue, element) =>
            previousValue + (previousValue.isNotEmpty ? ' ' : '') + element);

    return MyContact(
        id: contact.id,
        displayName: contact.displayName,
        name: name,
        phones: contact.phones
            .map((phone) => phone.normalizedNumber.isNotEmpty
                ? phone.normalizedNumber
                : phone.number)
            .toList());
  }
}
