import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:ejyption_time_2/models/participants/participant.dart';
import 'package:ejyption_time_2/models/withddd.dart';

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

class PointAssessment implements WithIdAndCreationAndParticipant {
  @override
  final String id = GlobalKey().toString();
  final DateTime _creation = DateTime.now();
  @override
  DateTime get creation => _creation;
  @override
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

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'participant': participant.toMap()});
    result.addAll({'meetingId': meetingId});
    result.addAll({'field': field});
    result.addAll({'keyStringValue': keyStringValue});
    result.addAll({'mark': mark.name});
    result.addAll({'commentText': commentText});

    return result;
  }

  factory PointAssessment.fromMap(Map<String, dynamic> map) {
    return PointAssessment(
      participant: Participant.fromMap(map['participant']),
      meetingId: map['meetingId'] ?? '',
      field: map['field'] ?? '',
      keyStringValue: map['keyStringValue'] ?? '',
      mark: PointMarks.values.byName(map['mark']),
      commentText: map['commentText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PointAssessment.fromJson(String source) =>
      PointAssessment.fromMap(json.decode(source));
}
