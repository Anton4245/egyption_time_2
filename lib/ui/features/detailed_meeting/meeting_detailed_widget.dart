import 'package:ejyption_time_2/ui/common_widgets/main_popup_menu.dart';
import 'package:ejyption_time_2/ui/common_widgets/new_assessment.dart';
import 'package:ejyption_time_2/ui/common_widgets/question.dart';
import 'package:ejyption_time_2/ui/common_widgets/templates.dart';
import 'package:ejyption_time_2/models/global/global_model.dart';
import 'package:ejyption_time_2/ui/features/detailed_meeting/constant_field_provider.dart';
import 'package:ejyption_time_2/ui/features/detailed_meeting/constant_field_widget.dart';
import 'package:ejyption_time_2/ui/features/detailed_meeting/meeting_detailed_provider.dart';
import 'package:ejyption_time_2/models/assesstments/probability_assesstment.dart';
import 'package:ejyption_time_2/ui/features/contacts/participants_selection_cover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ejyption_time_2/ui/common_widgets/input_string.dart';

class MeetingDetailed extends StatelessWidget {
  const MeetingDetailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<MeetingDetailedProvider>(context);
    Meeting meeting = model.meeting;
    ThemeData theme = Theme.of(context);
    ProbabilityAssessment? lastProbabilityAssessment =
        meeting.lastProbabilityAssessment();

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('created: ${meeting.creationToString}',
                  style: theme.textTheme.subtitle1),
            ),
            MyMainPadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    meeting.finallyNegotiated
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: theme.textTheme.headline6?.fontSize ?? 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 6,
                    child: Text(
                      meeting.finallyNegotiated
                          ? AppLocalizations.of(context)!.isFinallyNegotiated
                          : AppLocalizations.of(context)!
                              .inProcessOfNegotiation,
                      style: meeting.finallyNegotiated
                          ? theme.textTheme.subtitle1
                              ?.copyWith(color: theme.colorScheme.primary)
                          : theme.textTheme.subtitle1,
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox.shrink()),
                  ElevatedButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                                fontSize: theme.textTheme.subtitle1?.fontSize)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {},
                    child: Text(lastProbabilityAssessment == null
                        ? '   %'
                        : '${lastProbabilityAssessment.probability.toString()} %'),
                  ),
                  const Expanded(flex: 1, child: SizedBox.shrink()),
                  mainPopupMenu<MainMenu>(
                      theme,
                      model.createMainMenuList(lastProbabilityAssessment),
                      mainMenuProperties(meeting),
                      (menuItem) =>
                          mainMenuUIAction(context, meeting, model, menuItem))
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(meeting.name,
                    style: theme.textTheme.headline6!.copyWith(fontSize: 24))),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        model.participantsMenuOnSelected(
                            ParticipantsMenu.viewParticipants);
                        Navigator.of(context).pushNamed(
                            ParticipantsWidgetCover.routeName,
                            arguments: meeting.participants);
                      },
                      style: TextButton.styleFrom(
                          side: BorderSide(
                              color: theme.colorScheme.primary, width: 1)),
                      child: Container(
                        color: meeting.participants.modified
                            ? theme.colorScheme.tertiaryContainer
                            : null,
                        child: Text(
                          '${meeting.participants.value.length.toString()} ${AppLocalizations.of(context)!.participants}, ${meeting.calculateProbability().toStringAsFixed(1)} ${AppLocalizations.of(context)!.real}',
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ),
                  (meeting.finallyNegotiated &&
                          (GlobalModel
                                  .instance.currentParticipant?.isInitiator ??
                              false))
                      ? const SizedBox.shrink()
                      : mainPopupMenu<ParticipantsMenu>(
                          theme, null, participantsMenuProperties, (menuItem) {
                          model.participantsMenuOnSelected(menuItem);
                          if (menuItem == ParticipantsMenu.modifyParticipants) {
                            Navigator.of(context).pushNamed(
                                ParticipantsWidgetCover.routeName,
                                arguments: meeting.participants);
                          }
                        })
                ],
              ),
            ),
            Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...negotiatingFieldsDetailed(meeting, theme, context, model)
                ]),
          ],
        ),
      ),
    );
  }

  void mainMenuUIAction(context, meeting, model, menuItem) {
    if (menuItem == MainMenu.setProbabilityAssessment) {
      newAssessmentForm(
          context,
          meeting.name,
          ((result, values) =>
              model.processResultOfNewAssesment(result, values)));
    } else if (menuItem == MainMenu.editName) {
      TextEditingController _textFieldController = TextEditingController();
      _textFieldController.text = meeting.name;
      displayTextInputDialog(context, _textFieldController, 'Input new name')
          .then((result) => (result as bool)
              ? model.mainMenuOnSelected(menuItem, _textFieldController.text)
              : {});
    } else if (menuItem == MainMenu.deleteMeeting) {
      QuestionDialog(
              context, 'Are you sure that you want to DELETE this meeting?')
          .then((result) {
        if ((result as bool) == true) {
          Navigator.of(context).pop();
          return true;
        } else {
          return false;
        }
      }).then((value) => value ? model.mainMenuOnSelected(menuItem) : {});
    } else {
      model.mainMenuOnSelected(menuItem);
    }
  }

  List<Widget> negotiatingFieldsDetailed(
      Meeting meeting, ThemeData theme, BuildContext ctx, model) {
    List<Widget> l = List<Widget>.empty(growable: true);

    meeting.negotiatingFieldsMap.forEach((key, value) {
      if (true) {
        //value is NegotiatingString
        l.add(
          const Divider(
            height: 0,
            thickness: 1,
          ),
        );

        l.add(ChangeNotifierProvider<ConstantFieldProvider>(
          create: (_) => model.createConstantFieldProvider(value),
          // ignore: prefer_const_constructors
          child: CommonFieldWidget(),
        ));
      }
    });
    return l;
  }
}

Map<ParticipantsMenu, Map<MenuProp, dynamic>> participantsMenuProperties = {
  ParticipantsMenu.modifyParticipants: {
    MenuProp.icon: Icons.people,
    MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
        .modifyParticipantsList,
  },
};

Map<MainMenu, Map<MenuProp, dynamic>> mainMenuProperties(meeting) {
  return {
    MainMenu.changeFinallyNegotiated: {
      MenuProp.icon: !meeting.finallyNegotiated
          ? Icons.check_circle
          : Icons.circle_outlined,
      MenuProp.text: !meeting.finallyNegotiated
          ? AppLocalizations.of(GlobalModel.instance.commonContext!)!
              .setFinallyNegotiated
          : AppLocalizations.of(GlobalModel.instance.commonContext!)!
              .clearFinallyNegotiated
    },
    MainMenu.setProbabilityAssessment: {
      MenuProp.icon: Icons.percent,
      MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
          .setProbabilityAssessment
    },
    MainMenu.deleteProbabilityAssessment: {
      MenuProp.icon: Icons.delete_sweep,
      MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
          .deleteProbabilityAssessment
    },
    MainMenu.editName: {MenuProp.icon: Icons.edit, MenuProp.text: 'Edit name'},
    MainMenu.testSave: {MenuProp.icon: Icons.save, MenuProp.text: 'Save'},
    MainMenu.deleteMeeting: {
      MenuProp.icon: Icons.delete_forever,
      MenuProp.text: 'Delete meeting'
    },
  };
}
