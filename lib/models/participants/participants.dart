import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/participants/participant.dart';

import '../../core/extenstions.dart' as ttt;

class Participants with ChangeNotifier implements ModifiedObjectInterface {
  // ignore: unused_field, prefer_final_fields

  String _id = UniqueKey().toString();
  int _version = 0;
  void provideModifying([bool notify = true]) {
    _version++;
    if (notify) {
      notifyListeners();
    }
  }

  final List<Participant> _value = [];
  List<Participant> get value => _value;
  updatevalue(List<Participant> newList, [bool notify = true]) {
    _value.replaceMy(newList);
    provideModifying(notify);
  }

  final String _name = 'Participants';
  final String _parentID;
  final Object? _parent;
  Object? get parent => _parent;

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
  bool modified = false;
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

  Participants.json(
    this._version,
    this._parentID,
    this._parent,
    this.isModifying,
    this.modified,
    this.modifyingFormProvider,
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_version': _version});
    result.addAll({'_parentID': _parentID});
    result.addAll({'modified': modified});

    return result;
  }

  factory Participants.fromMap(Map<String, dynamic> map, Object? parent) {
    return Participants.json(
      map['_version']?.toInt() ?? 0,
      map['_parentID'] ?? '',
      map['_parent'] = parent,
      false,
      map['modified'] ?? false,
      null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Participants.fromJson(String source, Object? parent) =>
      Participants.fromMap(json.decode(source), parent);
}