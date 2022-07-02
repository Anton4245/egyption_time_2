import 'package:ejyption_time_2/models/participant.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:flutter/material.dart';

enum ProbablityMarks {
  isUnaware,
  mostCertainlyIsNot,
  maybe,
  veryLikely,
  definitelyYes
}

class ProbabilityAssessment {
  final String id = GlobalKey().toString();
  final DateTime _creation = DateTime.now();
  Participant participant;
  Meeting meeting;
  ProbablityMarks mark;

  ProbabilityAssessment({
    required this.meeting,
    this.mark = ProbablityMarks.isUnaware,
    required this.participant,
  });
}
