import 'package:ejyption_time_2/models/others/my_contact.dart';
import 'package:ejyption_time_2/models/participants/participant.dart';
import 'package:flutter/material.dart';

Widget avatar(MyContact myContact,
    [double radius = 48.0,
    ThemeData? theme,
    IconData defaultIcon = Icons.person]) {
  if (myContact.photoOrThumbnail != null) {
    return CircleAvatar(
      backgroundImage: MemoryImage(myContact.photoOrThumbnail!),
      radius: radius,
      backgroundColor: theme?.colorScheme.primaryContainer,
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: theme?.colorScheme.primary,
    child: Icon(
      defaultIcon,
      color: theme?.colorScheme.onPrimary,
    ),
  );
}

Widget avatar2(Participant participant,
    [double radius = 48.0,
    ThemeData? theme,
    IconData defaultIcon = Icons.person,
    MyContact? myContact]) {
  MyContact? curContact =
      (myContact != null) ? myContact : participant.myContact;
  if (curContact?.photoOrThumbnail != null) {
    return CircleAvatar(
      backgroundImage: MemoryImage(curContact!.photoOrThumbnail!),
      radius: radius,
      backgroundColor: theme?.colorScheme.primaryContainer,
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: theme?.colorScheme.primary,
    child: Text(
      participant.initials,
      style: theme?.textTheme.headline6!
          .copyWith(fontSize: radius, color: theme.colorScheme.onPrimary),
    ),
  );
}
