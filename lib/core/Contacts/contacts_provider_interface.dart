import 'package:ejyption_time_2/models/my_contact.dart';

abstract class ContactsProviderInterface {
  Future<List<MyContact>> getContacts();
  Future<bool> requestPermission({bool readonly = false});
  void addListener(void Function() listener) {}
}
