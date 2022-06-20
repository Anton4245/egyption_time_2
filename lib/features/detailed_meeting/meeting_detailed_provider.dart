import 'package:ejyption_time_2/features/detailed_meeting/constant_field_provider.dart';
import '../../models/meeting.dart';
import 'package:flutter/widgets.dart';

enum MainMenu {
  ChangeFinallyNegotiated,
}

class MeetingDetailedProvider with ChangeNotifier {
  final Meeting meeting;
  MeetingDetailedProvider(
    this.meeting,
  ) {
    meeting.addListener(listener);
  }

  listener() {
    notifyListeners();
  }

  @override
  dispose() {
    meeting.removeListener(listener);
    super.dispose();
  }

  ConstantFieldProvider createConstantFieldProvider(field) {
    return ConstantFieldProvider(field: field);
  }

  void mainMenuOnSelected(MainMenu menuItem) {
    if (menuItem == MainMenu.ChangeFinallyNegotiated) {
      meeting.setFinallyNegotiated(!meeting.finallyNegotiated);
    }
  }
}
