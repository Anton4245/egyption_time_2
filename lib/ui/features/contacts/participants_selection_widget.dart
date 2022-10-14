// ignore_for_file: unused_import

import 'package:ejyption_time_2/ui/common_widgets/avatar.dart';
import 'package:ejyption_time_2/ui/common_widgets/main_popup_menu.dart';
import 'package:ejyption_time_2/ui/common_widgets/templates.dart';
import 'package:ejyption_time_2/ui/features/contacts/participants_selection_provider.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/others/my_contact.dart';
import 'package:ejyption_time_2/models/participants/participants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantsSelectionWidget extends StatelessWidget {
  static const routeName = '/participants_selection_cover';
  final Participants participants;
  const ParticipantsSelectionWidget(this.participants, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return participants.isModifying
        ? ChangeNotifierProvider<ParticipantsSelectionProvider>.value(
            value: participants.modifyingFormProvider
                as ParticipantsSelectionProvider,
            child: Consumer<ParticipantsSelectionProvider>(
                builder: (ctx, model, _) => DefaultTabController(
                      length: model.modifyParticipants ? 3 : 1,
                      initialIndex: !model.modifyParticipants
                          ? 0
                          : model.editParticipants.isEmpty
                              ? 2
                              : 1,
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
                              !model.modifyParticipants
                                  ? const SizedBox.shrink()
                                  : mainPopupMenu<ParticipantsSelectionMenu>(
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
                                    text: model.modifyParticipants
                                        ? 'View Participants'
                                        : null,
                                    icon: Icon(
                                      Icons.people_alt,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                ...(model.modifyParticipants)
                                    ? [
                                        Tab(
                                          text: 'Modify participants',
                                          icon: Icon(Icons.people,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        Tab(
                                            text: 'Select phone contacts',
                                            icon: Icon(
                                              Icons.contact_page,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )),
                                      ]
                                    : []
                              ]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                const ParticipantsViewWidjet(),
                                ...(model.modifyParticipants)
                                    ? [
                                        const ParticipantsEditWidjet(),
                                        const ContactsWidget()
                                      ]
                                    : []
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

class ParticipantsViewWidjet extends StatelessWidget {
  const ParticipantsViewWidjet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ParticipantsSelectionProvider model =
        Provider.of<ParticipantsSelectionProvider>(context);

    return Column(
      children: [
        // MyBigPadding(
        //   child: Center(
        //       child: Text(
        //     'Tap Participant to view',
        //     style: theme.textTheme.bodyText1,
        //   )),
        // ), //
        Expanded(
          child: ListView.builder(
              itemCount: model.meetingParticipants.value.length,
              itemBuilder: (context, i) {
                final participant = model.meetingParticipants.value[i];

                MyContact? myContact = participant.myContact;
                myContact ??= model.findMyContact(participant.phonesEncripted);
                return ListTile(
                  leading: avatar2(
                      participant, 18.0, theme, Icons.person, myContact),
                  title: Text(myContact?.displayName ?? ''),
                  subtitle: Text(myContact?.phonesToString() ?? ''),
                  onTap: () {},
                );
              }),
        ),
      ],
    );
  }
}

class ParticipantsEditWidjet extends StatelessWidget {
  const ParticipantsEditWidjet({
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
              itemCount: model.editParticipants.length,
              itemBuilder: (context, i) {
                final participant = model.editParticipants[i];
                return ListTile(
                  leading: avatar2(participant, 18.0, theme),
                  title: Text(participant.myContact?.displayName ?? ''),
                  subtitle: Text(participant.myContact?.phonesToString() ?? ''),
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
                  leading: avatar(contact, 18.0, theme),
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
