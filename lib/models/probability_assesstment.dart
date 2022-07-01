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
  String id = GlobalKey().toString();
  Meeting meeting;
  ProbablityMarks mark;
  Participant participant;
  ProbabilityAssessment({
    required this.meeting,
    this.mark = ProbablityMarks.isUnaware,
    required this.participant,
  });
}
