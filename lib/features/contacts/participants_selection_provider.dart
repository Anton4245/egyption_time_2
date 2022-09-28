import 'package:ejyption_time_2/core/Contacts/contacts_impl_flutter_contacts.dart';
import 'package:ejyption_time_2/core/Contacts/contacts_provider_interface.dart';
import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/perticipants.dart';
import 'package:flutter/widgets.dart';

import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:ejyption_time_2/models/participant.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

enum ParticipantsSelectionMenu { saveChanges, discardChanges }

class ParticipantsSelectionProvider with ChangeNotifier {
  List<MyContact>? contacts;
  late final List<Participant> editParticipants;
  final Participants meetingParticipants;
  bool modifyParticipants;

  ContactsProviderInterface contactsProviderImpl = MyFlutterContacts();
  bool permissionDenied = false;
  int _version = 0;
  List<String> areExcluded = [];

  ParticipantsSelectionProvider(this.meetingParticipants,
      [this.modifyParticipants = false]) {
    bool isInitiator =
        GlobalModel.instance.currentParticipant?.isInitiator ?? false;
    modifyParticipants = (modifyParticipants && isInitiator) ? true : false;
    editParticipants = [...meetingParticipants.value];
    meetingParticipants.addListener(listener);
    _fetchContacts();
  }

  listener() {
    provideModifying();
  }

  void provideModifying() {
    _version++;
    notifyListeners();
  }

  @override
  dispose() {
    meetingParticipants.removeListener(listener);
    super.dispose();
  }

  Future _fetchContacts() async {
    bool res = await contactsProviderImpl.requestPermission(readonly: true);
    if (!res) {
      permissionDenied = true;
      provideModifying();
    } else {
      contacts = await contactsProviderImpl.getContacts();
      provideModifying();

      FlutterContacts.addListener(_loadContacts);

      ContactsProviderInterface.addListener(() => _loadContacts);
    }
  }

  Future _loadContacts() async {
    if (contacts == null) {
      contacts = [];
    } else {
      contacts!.clear();
    }
    contacts = await contactsProviderImpl.getContacts();

    provideModifying();
  }

  void addContactToParticipants(String id) {
    try {
      //StateError may be throwing, if no any element found
      MyContact myContact = contacts!.firstWhere((element) => element.id == id);
      areExcluded.add(myContact.id);
      editParticipants.add(Participant.fromMyContact(myContact));
      provideModifying();
    } catch (e) {
      return;
    }
  }

  void returnContactFromParticipants(Participant participant) {
    if (participant.contactId.isNotEmpty) {
      areExcluded.removeWhere((id) => id == participant.contactId);
    }
    editParticipants.removeWhere((element) => element.id == participant.id);
    provideModifying();
  }

  participantsSelectionMenuOnSelected(ParticipantsSelectionMenu menuItem) {
    switch (menuItem) {
      case ParticipantsSelectionMenu.saveChanges:
        meetingParticipants.isModifying = false;
        meetingParticipants.modifyingFormProvider = null;
        meetingParticipants.modified = true;
        (meetingParticipants.parent as Meeting).fieldsModified = true;
        meetingParticipants.updatevalue(editParticipants);
        break;
      case ParticipantsSelectionMenu.discardChanges:
        meetingParticipants.isModifying = false;
        meetingParticipants.modifyingFormProvider = null;
        break;
    }
  }
}
