import 'package:ejyption_time_2/models/meeting.dart';
import 'package:flutter/material.dart';

class TestMeeting {
  static Meeting giveAnyTestMeeting() {
    Set<String> newSet = Set.of(Meeting.possibleNegotiatingFields);
    //newSet.removeWhere((element) => element == '_lenthInDays');

    Meeting newMeeting = Meeting(negotiatingFields: newSet);
    newMeeting.setName('Bath in New Komarovka');
    newMeeting.shedule.setProvisionalValue(
        '3 hours of bath, meeting 1 hour befor at the trolleybus stop near the entrance to the park. Please don\'t be late. If anyone will be late, go farward to bath direction',
        false);
    newMeeting.shedule
        .addProvisionalVariant('If somebody is too busy, don\'t come', false);
    newMeeting.shedule.addProvisionalVariant('Don\'t come forever', false);
    //newMeeting.dayOfMeeting.setIsExcluded(true, TestMeeting());
    newMeeting.lenthInMinutesAndHours.setValue(DateTime(0, 0, 0, 4), false);
    newMeeting.dayOfMeeting.setValue(DateTime(2022, 6, 1), false);
    newMeeting.timeOfMeeting.setProvisionalValue('Вечером после работы', false);
    return newMeeting;
  }

  static List<Meeting> giveAnyListOfMeetings() {
    return List<Meeting>.generate(30, (index) {
      Meeting newMeeting = giveAnyTestMeeting();
      newMeeting.dayOfMeeting.setValue(
          newMeeting.dayOfMeeting.value?.add(Duration(days: index)), false);
      newMeeting.setName('${newMeeting.name} ${index + 1}');
      newMeeting.lenthInMinutesAndHours.setIsNegotiated(true, false);
      return newMeeting;
    });
  }

  static List<Map<String, dynamic>> getColorProperties(ThemeData scheme) {
    List<Map<String, dynamic>> colorProperties = [
      {'color': scheme.colorScheme.primary, 'name': 'primary'},
      {
        'color': scheme.colorScheme.primaryContainer,
        'name': 'primaryContainer'
      },
      {'color': scheme.colorScheme.onPrimary, 'name': 'onPrimary'},
      {
        'color': scheme.colorScheme.onPrimaryContainer,
        'name': 'onPrimaryContainer'
      },
      {'color': scheme.colorScheme.secondary, 'name': 'secondary'},
      {
        'color': scheme.colorScheme.secondaryContainer,
        'name': 'secondaryContainer'
      },
      {'color': scheme.colorScheme.onSecondary, 'name': 'onSecondary'},
      {
        'color': scheme.colorScheme.onSecondaryContainer,
        'name': 'onSecondaryContainer'
      },
      {'color': scheme.colorScheme.tertiary, 'name': 'tertiary'},
      {
        'color': scheme.colorScheme.tertiaryContainer,
        'name': 'tertiaryContainer'
      },
      {'color': scheme.colorScheme.onTertiary, 'name': 'onTertiary'},
      {
        'color': scheme.colorScheme.onTertiaryContainer,
        'name': 'onTertiaryContainer'
      },
      {'color': scheme.colorScheme.error, 'name': 'error'},
      {'color': scheme.colorScheme.errorContainer, 'name': 'errorContainer'},
      {'color': scheme.colorScheme.onError, 'name': 'onError'},
      {
        'color': scheme.colorScheme.onErrorContainer,
        'name': 'onErrorContainer'
      },
      {'color': scheme.colorScheme.surface, 'name': 'surface'},
      {'color': scheme.colorScheme.onSurface, 'name': 'onSurface'},
      {'color': scheme.colorScheme.background, 'name': 'background'},
      {'color': scheme.colorScheme.onBackground, 'name': 'onBackground'},
      {'color': scheme.colorScheme.surfaceVariant, 'name': 'surfaceVariant'},
      {
        'color': scheme.colorScheme.onSurfaceVariant,
        'name': 'onSurfaceVariant'
      },
      {'color': scheme.colorScheme.inverseSurface, 'name': 'inverseSurface'},
      {
        'color': scheme.colorScheme.onInverseSurface,
        'name': 'onInverseSurface'
      },
      {'color': scheme.colorScheme.outline, 'name': 'outline'},
      {'color': scheme.colorScheme.inversePrimary, 'name': 'inversePrimary'},
      {'color': scheme.colorScheme.shadow, 'name': 'shadow'},
    ];

    return colorProperties;
  }
}
