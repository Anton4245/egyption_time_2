import 'dart:convert';

import 'package:ejyption_time_2/core/shared/main_functions.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ejyption_time_2/models/shared/modified_objects.dart';
import 'package:ejyption_time_2/models/participants/participant.dart';

import '../../core/shared/extenstions.dart' as ttt;

class Participants with ChangeNotifier implements ModifiedObjectInterface {
  // ignore: unused_field, prefer_final_fields

  String _id = UniqueKey().toString();
  int _version = 0;
  void provideModifying([bool notify = true]) {
    _version++;
    if (notify) {
      notifyListeners();
      _parent.notifyMeeting();
    }
  }

  final List<Participant> _value = [];
  List<Participant> get value => _value;
  updatevalue(List<Participant> newList, [bool notify = true]) {
    _value.replaceMy(newList);
    provideModifying(notify);
  }

  setModifiedOnly(bool modified) {
    _modified = modified;
  }

  final String _name = 'Participants';
  final String _parentID;
  final Meeting _parent;
  Meeting get parent => _parent;

  //FOR INTERFACE ModifiedObjectInterface
  @override
  String get nameForModifying => _name;
  @override
  int get version => _version;
  @override
  String get idForModifying => _parentID;
  @override
  @JsonKey(ignore: true)
  bool isModifying = false;
  @override
  bool _modified = false;
  bool get modified => _modified;
  set modified(bool modified) {
    _modified = modified;
    _parent.setMeetingFielsModified();
  }

  @override
  PartsOfField partOfField = PartsOfField.value;
  @override
  Object? modifyingFormProvider;

  @override
  Map<String, dynamic> mapOfValuableFields() {
    Map<String, dynamic> m = {};
    m.addAll({
      '_value': _value,
    });
    return m;
  }

  Participants(
    this._parentID,
    this._parent,
  );

  @override
  notifyListeners() {
    super.notifyListeners();
    _parent.notifyMeeting();
  }

  Participants.forJSON(
    this._id,
    this._version,
    this._parentID,
    this._parent,
    this._modified,
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': _id});
    result.addAll({'_version': _version});
    result.addAll({'_parentID': _parentID});
    result.addAll({'modified': modified});
    result.addAll(
        {'_value': _value.map((participant) => participant.toMap()).toList()});

    return result;
  }

  factory Participants.fromMap(Map<String, dynamic> map, Meeting parent) {
    return Participants.forJSON(
      map['_id'],
      map['_version']?.toInt() ?? 0,
      map['_parentID'] ?? '',
      parent,
      map['modified'] ?? false,
    ).._value.addAll((map['_value'] as List).isEmpty
        ? <Participant>[]
        : [
            ...(map['_value'] as List<dynamic>)
                .map((m) => Participant.fromMap(m as Map<String, dynamic>))
                .toList()
          ]);
  }

  String toJson() => json.encode(toMap(), toEncodable: myDateSerializer);

  factory Participants.fromJson(String source, Meeting parent) =>
      Participants.fromMap(json.decode(source), parent);
}
