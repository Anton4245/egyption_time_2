// ignore_for_file: unused_import

import 'package:ejyption_time_2/core/common_widgets/avatar.dart';
import 'package:ejyption_time_2/core/common_widgets/main_popup_menu.dart';
import 'package:ejyption_time_2/core/common_widgets/templates.dart';
import 'package:ejyption_time_2/features/contacts/participants_selection_provider.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:ejyption_time_2/models/perticipants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantsSelectionWidget extends StatelessWidget {
  static const routeName = '/participants_selection_cover';
  Participants participants;
  ParticipantsSelectionWidget(this.participants, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return participants.isModifying
        ? ChangeNotifierProvider<ParticipantsSelectionProvider>.value(
            value: participants.modifyingFormProvider
                as ParticipantsSelectionProvider,
            child: Consumer<ParticipantsSelectionProvider>(
                builder: (ctx, model, _) => DefaultTabController(
                      length: 2,
                      initialIndex: model.localParticipants.isEmpty ? 1 : 0,
                      child: Column(
                        children: [
                          MyBigPadding(
                              child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (model.meetingParticipants.parent as Meeting)
                                      .name,
                                  style: theme.textTheme.headline5,
                                ),
                              ),
                              mainPopupMenu<ParticipantsSelectionMenu>(
                                  theme, null, participantsMenuProperties,
                                  (menuItem) {
                                model.participantsSelectionMenuOnSelected(
                                    menuItem);
                                Navigator.pop(context);
                              })
                            ],
                          )),
                          TabBar(
                              indicatorColor: theme.colorScheme.primary,
                              labelColor: theme.colorScheme.primary,
                              tabs: [
                                Tab(
                                  text: 'Participants',
                                  icon: Icon(Icons.people,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Tab(
                                    text: 'Select phone contacts',
                                    icon: Icon(
                                      Icons.contact_page,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              ]),
                          const Expanded(
                            child: TabBarView(
                              children: [
                                ParticipantsWidjet(),
                                ContactsWidget()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
          )
        : const Text('Is not yet implemented');
  }
}

const Map<ParticipantsSelectionMenu, Map<MenuProp, dynamic>>
    participantsMenuProperties = {
  ParticipantsSelectionMenu.saveChanges: {
    MenuProp.icon: Icons.save,
    MenuProp.text: 'Save participants'
  },
  ParticipantsSelectionMenu.discardChanges: {
    MenuProp.icon: Icons.exit_to_app,
    MenuProp.text: 'Cancel'
  },
};

class ParticipantsWidjet extends StatelessWidget {
  const ParticipantsWidjet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ParticipantsSelectionProvider model =
        Provider.of<ParticipantsSelectionProvider>(context);

    return Column(
      children: [
        MyBigPadding(
          child: Center(
              child: Text(
            'Tap Participant to remove',
            style: theme.textTheme.bodyText1,
          )),
        ), //
        Expanded(
          child: ListView.builder(
              itemCount: model.localParticipants.length,
              itemBuilder: (context, i) {
                final participant = model.localParticipants![i];
                return ListTile(
                  leading: Avatar2(participant, 18.0, theme),
                  title: Text(participant.displayName),
                  subtitle: Text(participant.name),
                  onTap: () {
                    model.returnContactFromParticipants(participant);
                  },
                );
              }),
        ),
      ],
    );
  }
}

class ContactsWidget extends StatelessWidget {
  const ContactsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ParticipantsSelectionProvider model =
        Provider.of<ParticipantsSelectionProvider>(context);

    if (model.permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (model.contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    List<MyContact> mewList = [...model.contacts!];
    mewList.removeWhere(
        (element) => model.areExcluded.any((id) => id == element.id));
    return Column(
      children: [
        MyBigPadding(
          child: Center(
              child: Text(
            'Tap contact to add to Participants list',
            style: theme.textTheme.bodyText1,
          )),
        ), //
        Expanded(
          child: ListView.builder(
              itemCount: mewList.length,
              itemBuilder: (context, i) {
                final contact = mewList[i];
                return ListTile(
                  leading: Avatar(contact, 18.0, theme),
                  title: Text(contact.displayName),
                  onTap: () {
                    model.addContactToParticipants(contact.id);
                  },
                );
              }),
        ),
      ],
    );
  }
}
