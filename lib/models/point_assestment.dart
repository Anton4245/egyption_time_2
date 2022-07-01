import 'package:ejyption_time_2/models/participant.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:flutter/material.dart';

enum PointMarks { isUnaware, unFit, soSo, fit }

class ProbabilityAssessment {
  String id = GlobalKey().toString();
  Meeting meeting;
  PointMarks mark;
  Participant participant;
  ProbabilityAssessment({
    required this.meeting,
    this.mark = PointMarks.isUnaware,
    required this.participant,
  });
}
