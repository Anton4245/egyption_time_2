import 'dart:convert';

import 'package:ejyption_time_2/core/shared/main_functions.dart';
import 'package:flutter/material.dart';

import 'package:ejyption_time_2/models/participants/participant.dart';
import 'package:ejyption_time_2/models/assesstments/3_fields_interface.dart';

enum ProbabilityMarks {
  isUnaware,
  mostCertainlyIsNot,
  maybe,
  possibly,
  likely,
  veryLikely,
  definitelyYes
}

const Map<ProbabilityMarks, String> probabilityNames = {
  ProbabilityMarks.isUnaware: 'Is unaware',
  ProbabilityMarks.mostCertainlyIsNot: 'Most certainly, not',
  ProbabilityMarks.maybe: 'Maybe',
  ProbabilityMarks.possibly: 'Possibly',
  ProbabilityMarks.likely: 'Likely',
  ProbabilityMarks.veryLikely: 'Very likely',
  ProbabilityMarks.definitelyYes: 'Definitely, yes',
};

const Map<ProbabilityMarks, int> probabilityNumbers = {
  ProbabilityMarks.isUnaware: -1,
  ProbabilityMarks.mostCertainlyIsNot: 5,
  ProbabilityMarks.maybe: 25,
  ProbabilityMarks.possibly: 45,
  ProbabilityMarks.likely: 55,
  ProbabilityMarks.veryLikely: 75,
  ProbabilityMarks.definitelyYes: 95,
};

class ProbabilityAssessment implements WithIdAndCreationAndParticipant {
  late final String _id;
  @override
  String get id => _id;
  late final DateTime _creation;
  @override
  DateTime get creation => _creation;
  @override
  final Participant participant;
  final String meetingId;
  ProbabilityMarks mark;
  late int probability;
  String assessmentText;

  ProbabilityAssessment({
    String? id,
    DateTime? creation,
    required this.participant,
    required this.meetingId,
    this.mark = ProbabilityMarks.isUnaware,
    this.probability = -1,
    this.assessmentText = '',
  }) {
    _id = id ?? UniqueKey().toString();
    _creation = creation ?? DateTime.now();
    if (probability == -1) {
      probability = probabilityNumbers[mark] ?? 0;
    }
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': _id});
    result.addAll({'_creation': _creation});
    result.addAll({'participant': participant.toMap()});
    result.addAll({'meetingId': meetingId});
    result.addAll({'mark': mark.name});
    result.addAll({'probability': probability.toString()});
    result.addAll({'assessmentText': assessmentText});

    return result;
  }

  factory ProbabilityAssessment.fromMap(Map<String, dynamic> map) {
    return ProbabilityAssessment(
      id: map['_id'],
      creation: DateTime.tryParse(map['_creation']) ?? DateTime.now(),
      participant: Participant.fromMap(map['participant']),
      meetingId: map['meetingId'] ?? '',
      mark: ProbabilityMarks.values.byName(map['mark']),
      probability: int.tryParse(map['probability']) ?? 0,
      assessmentText: map['assessmentText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap(), toEncodable: myDateSerializer);

  factory ProbabilityAssessment.fromJson(String source) =>
      ProbabilityAssessment.fromMap(json.decode(source));
}
