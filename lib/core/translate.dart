import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String tR(String text, BuildContext context) {
  if (AppLocalizations.of(context) == null) {
    return '';
  }
  switch (text) {
    case '_description':
      return AppLocalizations.of(context)!.description;
    case '_lenthInDays':
      return AppLocalizations.of(context)!.lenthInDays;
    case '_lenthInMinutesAndHours':
      return AppLocalizations.of(context)!.lenthInMinutesAndHours;
    case '_shedule':
      return AppLocalizations.of(context)!.shedule;
    case '_dayOfMeeting':
      return AppLocalizations.of(context)!.dayOfMeeting;
    case '_timeOfMeeting':
      return AppLocalizations.of(context)!.timeOfMeeting;
    default:
      return 'some';
  }
}
