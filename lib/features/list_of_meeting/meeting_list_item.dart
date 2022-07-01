import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/negotiating_field.dart';
import 'package:ejyption_time_2/screens/Meeting_cover_over_detailed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MeetingListItem extends StatelessWidget {
  final Map<String, dynamic> colorProperty;
  const MeetingListItem(
    this.colorProperty, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<Meeting>(
      builder: (context, meeting, child) {
        return GestureDetector(
          onTap: () {
            //to do - try to locate the detailed widget near this list in Landscape mode
            Navigator.of(context).pushNamed(MeetingCoverOverDetailed.routeName,
                arguments: meeting);
          },
          child: Card(
            //FIRST - TEMPORABLY
            color: colorProperty['color'] ??
                (meeting.modified || meeting.fieldsModified
                    ? theme.colorScheme.tertiaryContainer
                    : theme.colorScheme.secondaryContainer),
            elevation: 4,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //TEMPORABLY
                    children: [
                      Text(colorProperty['name']),
                      Text(
                        ' ' + colorProperty['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'creation: ${meeting.creationToString}',
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                      Icon(
                        meeting.finallyNegotiated
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: theme.textTheme.headline6?.fontSize ?? 20,
                        color: theme.colorScheme.primary,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    meeting.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [...negotiatingFields(meeting, theme)]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<Widget> negotiatingFields(Meeting meeting, ThemeData theme) {
  List<Widget> l = List<Widget>.empty(growable: true);

  meeting.negotiatingFieldsMap.forEach((key, value) {
    if (true) {
      //value is NegotiatingString
      l.add(NegotiatingFieldWidget(key, value, theme));
    }
  });
  return l;
}

class NegotiatingFieldWidget extends StatelessWidget {
  final String name;
  final NegotiatingField field;
  final ThemeData theme;

  const NegotiatingFieldWidget(
    this.name,
    this.field,
    this.theme, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            field.isNegotiated
                ? Icons.check_circle
                : field.isSelected
                    ? Icons.check_circle_outline
                    : null,
            color: theme.colorScheme.primary,
            size: (theme.textTheme.bodyText1?.fontSize ?? 16) * 1,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              '$name: $field',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: field.isSelected
                  ? theme.textTheme.bodyText1
                  : theme.textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
