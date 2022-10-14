import 'package:ejyption_time_2/ui/features/contacts/participants_selection_widget.dart';
import 'package:ejyption_time_2/models/participants/participants.dart';
import 'package:flutter/material.dart';

class ParticipantsWidgetCover extends StatelessWidget {
  const ParticipantsWidgetCover({Key? key}) : super(key: key);

  static const routeName = '/participants_selection_cover';

  @override
  Widget build(BuildContext context) {
    Participants participants = (ModalRoute.of(context)?.settings.arguments ??
        Participants('', this)) as Participants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: ParticipantsSelectionWidget(participants),
    );
  }

  // return ChangeNotifierProvider<ParticipantsSelectionProvider>.value(
  //       value: meeting.participants.modifyingFormProvider
  //           as ParticipantsSelectionProvider,
  //       child: Consumer<ParticipantsSelectionProvider>(
  //           builder: (ctx, model, _) => DefaultTabController(
  //               length: 2,
  //               child: Scaffold(
  //                 appBar: AppBar(
  //                   title: const Text('Title'),
  //                 ),
  //                 body: const ParticipantsSelectionWidget(),
  //               ))));
  // }
}
