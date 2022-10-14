import 'package:ejyption_time_2/ui/features/detailed_meeting/meeting_detailed_provider.dart';

import 'package:ejyption_time_2/ui/features/detailed_meeting/meeting_detailed_widget.dart';
import 'package:flutter/material.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:provider/provider.dart';

class MeetingCoverOverDetailed extends StatelessWidget {
  const MeetingCoverOverDetailed({Key? key}) : super(key: key);

  static const routeName = '/meeing_cover_over_deailed';

  @override
  Widget build(BuildContext context) {
    Meeting meeting =
        (ModalRoute.of(context)?.settings.arguments ?? Meeting()) as Meeting;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: ChangeNotifierProvider<MeetingDetailedProvider>.value(
          value: MeetingDetailedProvider(meeting),
          child: const MeetingDetailed()),
    );
  }
}
