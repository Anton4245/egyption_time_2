import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/features/list_of_meeting/meeting_list_provider.dart';
import 'package:ejyption_time_2/core/test_meeting.dart';
import 'package:ejyption_time_2/features/list_of_meeting/meeting_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> colorProperties =
        TestMeeting.getColorProperties(Theme.of(context));
    return Consumer<Meetings>(
      builder: (context, meetings, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () => meetings.changeModel(),
                child: const Text('Change meetings')),
            Expanded(
              child: ListView.builder(
                  itemCount: GlobalModel.instance.meetingList.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<Meeting>.value(
                        value: meetings.meetingList[index],
                        child: MeetingListItem(colorProperties.length >
                                    index - 3 &&
                                index >= 3
                            ? colorProperties[index - 3]
                            : {
                                'color': null,
                                'name': 'default'
                              })); // ?? {'color':Colors.green, 'name': 'green'}
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
