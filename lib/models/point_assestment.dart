import 'dart:convert';

import 'package:ejyption_time_2/core/main_functions.dart';
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
  late final String _id;
  @override
  String get id => _id;
  late final DateTime _creation;
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
      {String? id,
      DateTime? creation,
      required this.participant,
      required this.meetingId,
      required this.field,
      required this.keyStringValue,
      this.mark = PointMarks.isUnaware,
      this.commentText = ''})
      : _id = id ?? UniqueKey().toString(),
        _creation = creation ?? DateTime.now();

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': _id});
    result.addAll({'_creation': _creation});
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
      id: map['_id'],
      creation: DateTime.tryParse(map['_creation']) ?? DateTime.now(),
      participant: Participant.fromMap(map['participant']),
      meetingId: map['meetingId'] ?? '',
      field: map['field'] ?? '',
      keyStringValue: map['keyStringValue'] ?? '',
      mark: PointMarks.values.byName(map['mark']),
      commentText: map['commentText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap(), toEncodable: myDateSerializer);

  factory PointAssessment.fromJson(String source) =>
      PointAssessment.fromMap(json.decode(source));
}
