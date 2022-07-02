import 'package:flutter/material.dart';

import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/participant.dart';

enum PointMarks { isUnaware, unFit, soSo, fit }
const Map<PointMarks, String> pointMarksNames = {
  PointMarks.isUnaware: "Is unaware",
  PointMarks.unFit: "Unfit",
  PointMarks.soSo: "So-so",
  PointMarks.fit: "Fit"
};
const Map<PointMarks, IconData> pointMarksIcon = {
  PointMarks.isUnaware: Icons.question_mark,
  PointMarks.unFit: Icons.square_outlined,
  PointMarks.soSo: Icons.square,
  PointMarks.fit: Icons.add_box
};

class PointAssessment {
  final String id = GlobalKey().toString();
  final DateTime _creation = DateTime.now();
  DateTime get creation => _creation;
  Participant participant;
  String meetingId;
  String field;
  String keyStringValue;
  PointMarks mark;
  String commentText;

  PointAssessment(
      {required this.participant,
      required this.meetingId,
      required this.field,
      required this.keyStringValue,
      this.mark = PointMarks.isUnaware,
      this.commentText = ''});
}
