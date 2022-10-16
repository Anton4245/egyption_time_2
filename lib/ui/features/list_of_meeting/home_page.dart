import 'package:ejyption_time_2/models/global/global_model.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/global/meetings_global.dart';
import 'package:ejyption_time_2/models/global/test_meeting.dart';
import 'package:ejyption_time_2/ui/common_widgets/input_string.dart';
import 'package:ejyption_time_2/ui/common_widgets/question.dart';
import 'package:ejyption_time_2/ui/features/list_of_meeting/meeting_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalModel.instance.commonContext = context;
    List<Map<String, dynamic>> colorProperties =
        TestMeeting.getColorProperties(Theme.of(context));
    Meetings meetings = Provider.of<Meetings>(context);
    if (meetings.listIsUpdating && meetings.actionToDo != null) {
      meetings.activateUpdateAction();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
              onPressed: () {
                TextEditingController _textFieldController =
                    TextEditingController();
                displayTextInputDialog(context, _textFieldController,
                        'Input name of new Meeting')
                    .then((value) => (value as bool)
                        ? meetings.addNewMeeting(_textFieldController.text)
                        : {});
              },
              icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () => QuestionDialog(context,
                    'Are you sure that you want to share new meeting and modified ones with other?')
                .then((result) =>
                    (result as bool) ? meetings.shareUpdaits() : {}),
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: meetings.listIsUpdating
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: GlobalModel.instance.meetingList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider<Meeting>.value(
                            value: meetings.meetingList[index],
                            child: MeetingListItem(
                                colorProperties.length > index - 3 && index >= 3
                                    ? colorProperties[index - 3]
                                    : {'color': null, 'name': 'default'}));
                      }),
                ),
              ],
            ),
    );
  }
}
