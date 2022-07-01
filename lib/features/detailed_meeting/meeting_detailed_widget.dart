import 'package:ejyption_time_2/core/common_widgets/main_popup_menu.dart';
import 'package:ejyption_time_2/core/common_widgets/templates.dart';
import 'package:ejyption_time_2/features/detailed_meeting/constant_field_provider.dart';
import 'package:ejyption_time_2/features/detailed_meeting/constant_field_widget.dart';
import 'package:ejyption_time_2/features/detailed_meeting/meeting_detailed_provider.dart';
import 'package:ejyption_time_2/screens/participants_selection_cover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/negotiating_field.dart';

class MeetingDetailed extends StatelessWidget {
  const MeetingDetailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<MeetingDetailedProvider>(context);
    Meeting meeting = model.meeting;
    ThemeData theme = Theme.of(context);

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
                    child: Text(
                      meeting.finallyNegotiated
                          ? 'Is finally negotiated'
                          : 'In process of negotiation',
                      style: meeting.finallyNegotiated
                          ? theme.textTheme.subtitle1
                              ?.copyWith(color: theme.colorScheme.primary)
                          : theme.textTheme.subtitle1,
                    ),
                  ),
                  mainPopupMenu<MainMenu>(
                      theme, null, mainMenuProperties(meeting), (menuItem) {
                    model.mainMenuOnSelected(menuItem);
                  })
                ],
              ),
            ),
            MyMainPadding(
                hasBorder: false,
                child: Text(meeting.name,
                    style: theme.textTheme.headline6!.copyWith(fontSize: 24))),
            MyMainPadding(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    color: meeting.participants.modified
                        ? theme.colorScheme.tertiaryContainer
                        : null,
                    child: Text(
                      meeting.participants.value.length.toString() +
                          ' participants',
                      style: theme.textTheme.subtitle1,
                    ),
                  )),
                  mainPopupMenu<ParticipantsMenu>(
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

const Map<ParticipantsMenu, Map<MenuProp, dynamic>> participantsMenuProperties =
    {
  ParticipantsMenu.modifyParticipants: {
    MenuProp.icon: Icons.people,
    MenuProp.text: 'Modify participants list'
  },
};

Map<MainMenu, Map<MenuProp, dynamic>> mainMenuProperties(meeting) {
  return {
    MainMenu.changeFinallyNegotiated: {
      MenuProp.icon: !meeting.finallyNegotiated
          ? Icons.check_circle
          : Icons.circle_outlined,
      MenuProp.text: !meeting.finallyNegotiated
          ? 'Set <Finally negotiated>'
          : 'Clear <Finally negotiated>'
    },
  };
}

class DetailedVariantsWidget extends StatelessWidget {
  final NegotiatingField field;
  const DetailedVariantsWidget({Key? key, required this.field})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 4,
        ),
        ...((field.isSelected) ? field.variants : field.provisionalVariants)
            .map((val) => Container(
                  color: field.modified
                      ? theme.colorScheme.tertiaryContainer
                      : null,
                  child: Text(
                    '  - ${val.toString()}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: (field.isSelected
                        ? theme.textTheme.bodyText1
                        : theme.textTheme.bodyText2),
                  ),
                ))
      ],
    );
  }
}
