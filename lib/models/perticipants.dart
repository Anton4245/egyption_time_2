import 'package:flutter/cupertino.dart';

import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/participant.dart';
import '../core/extenstions.dart' as ttt;

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
}
