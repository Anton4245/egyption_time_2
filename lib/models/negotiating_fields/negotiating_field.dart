import 'dart:convert';
import 'dart:math';

import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/core/main_functions.dart';
import 'package:ejyption_time_2/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/point_assestment.dart';
import 'package:ejyption_time_2/models/withddd.dart';
import 'package:ejyption_time_2/screens/participants_selection_cover.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../core/extenstions.dart' as ttt;

part 'negotiating_field.types.dart';

abstract class NegotiatingField<T extends Object>
    with ChangeNotifier
    implements ModifiedObjectInterface<ModifyingFieldProvider> {
  String mainFormat(Object? val) {
    return val?.toString() ?? '';
  }

  //SERVICE FIELDS
  // in case of [_isExcluded == true] this property will not be included in Meeting class
  bool _isExcluded = false;
  bool get isExcluded => _isExcluded;
  setIsExcluded(bool isExcluded, context) {
    if (context is Meeting) {
      _version++;
      _isExcluded = isExcluded;
    } else {
      throw Exception(
          'It is not possible to set call [setIsExcluded] of [Meeting] property outside of [Meeting] constructor');
    }
  }

  int _version = 0;
  final String _name;
  String get name => _name;
  final String _parentID;
  final Object? _parent;
  Object? get parent => _parent;
  Type get typeOfvalue => T;

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
  ModifyingFieldProvider? modifyingFormProvider;

  @override
  Map<String, dynamic> mapOfValuableFields() {
    Map<String, dynamic> m = {};
    m.addAll({
      '_hasStringProvisionalValue': _hasStringProvisionalValue,
      '_provisionalValue': _provisionalValue,
      '_isSelected': _isSelected,
      '_value': _value,
      '_isNegotiated': _isNegotiated,
      '_variants': _variants,
      '_provisionalVariants': _provisionalVariants
    });
    return m;
  }

  void provideModifying([bool notify = true]) {
    _version++;
    if (notify) {
      notifyListeners();
    }
  }

  //DATA FIELDS
  //provisional value of the field in text format
  bool _hasStringProvisionalValue = false;
  bool get hasStringProvisionalValue => _hasStringProvisionalValue;
  String _provisionalValue = '';
  String get provisionalValue => _provisionalValue;
  setProvisionalValue(String newValue, [bool notify = true]) {
    _provisionalValue = newValue;
    _hasStringProvisionalValue = true;
    provideModifying(notify);
  }

  clearProvisionalValue([bool notify = true]) {
    _provisionalValue = '';
    _hasStringProvisionalValue = false;
    provideModifying(notify);
  }

  //list of value variants
  final List<String> _provisionalVariants = [];
  List<String> get provisionalVariants => _provisionalVariants;
  addProvisionalVariant(String val, [bool notify = true]) {
    if (_provisionalVariants.addSmartMy(val)) {
      provideModifying(notify);
    }
  }

  updateProvisionalVariants(Iterable<String> newList, [bool notify = true]) {
    _provisionalVariants.replaceMy(newList);
    provideModifying(notify);
  }

  //main value of the field
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  T? _value; //value can be null
  T? get value => _value;
  setValue(T? newValue, [bool notify = true]) {
    _value = newValue;
    _isSelected = true;
    provideModifying(notify);
  }

  clearValue([bool notify = true]) {
    _value = null;
    _isSelected = false;
    provideModifying(notify);
  }

  //list of value variants
  final List<T?> _variants = [];
  List<T?> get variants => _variants;
  addPVariant(T? val, [bool notify = true]) {
    if (_variants.addSmartMy(val)) {
      provideModifying(notify);
    }
  }

  updatelVariants(Iterable<T?> newList, [bool notify = true]) {
    _variants.replaceMy(newList);
    provideModifying(notify);
  }

  //list of Comments
  final Map<String, List<PointAssessment>> _pointAssesstments = {};
  Map<String, List<PointAssessment>> get pointAssesstments =>
      Map.fromEntries(_pointAssesstments.entries);
  void updatePointAssessments(Map<String, List<PointAssessment>> map) {
    _pointAssesstments.clear();
    _pointAssesstments.addAll(map);
  }

  void addPointAssesstment(PointAssessment newPointAssessment,
      [bool notify = true]) {
    List<PointAssessment> list = _pointAssesstments.putIfAbsent(
        newPointAssessment.keyStringValue, () => []);
    list.add(newPointAssessment);
    list.sort((a, b) => -a.creation.compareTo(b.creation));
    provideModifying(notify);
  }

  List<PointAssessment> getListOfAssessmentByKeyString(keyStringValue,
      {int length = 1000000}) {
    List<PointAssessment> list =
        _pointAssesstments[keyStringValue] ?? <PointAssessment>[];
    return [...list.getRange(0, min(list.length, length))];
  }

  void removePointAssesstment(String keyStringValue, [bool notify = true]) {
    //1. find needed comment
    if ((GlobalModel.instance.currentParticipant == null) ||
        _pointAssesstments[keyStringValue] == null) {
      return;
    }

    deleteLastListMember(_pointAssesstments[keyStringValue]!);
    provideModifying(notify);
  }

  //mark if the field has been negotiated
  bool _isNegotiated = false;
  bool get isNegotiated => _isNegotiated;
  setIsNegotiated(bool mark, [bool notify = true]) {
    _isNegotiated = mark;
    provideModifying(notify);
  }

  NegotiatingField(this._name, this._parentID, this._parent);

  String valueToString() {
    return mainFormat(_value);
  }

  //form the presentation of current value of the field
  @override
  String toString() {
    String resultString = '';

    if (isSelected) {
      resultString = valueToString();
    } else if (_hasStringProvisionalValue) {
      resultString = _provisionalValue;
    }
    return resultString;
  }

  String toKeyString() {
    String resultString = '';

    if (isSelected) {
      resultString = keyString(value);
    } else if (_hasStringProvisionalValue) {
      resultString = keyString(_provisionalValue);
    }

    return resultString;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_isExcluded': _isExcluded});
    result.addAll({'_version': _name});
    result.addAll({'_name': _name});
    result.addAll({'_name': _name});
    result.addAll({'_parentID': _parentID});
    result.addAll({'modified': modified});
    result.addAll({
      '_hasStringProvisionalValue': _hasStringProvisionalValue,
      '_provisionalValue': _provisionalValue,
      '_isSelected': _isSelected,
      '_value': _value,
      '_isNegotiated': _isNegotiated
    });
    result.addAll({'_provisionalVariants': _provisionalVariants});
    result.addAll({'_variants': _variants});
    result.addAll({
      '_pointAssesstments': _pointAssesstments.map((key, list) =>
          MapEntry(key, list.map((assessment) => assessment.toMap()).toList()))
    });

    return result;
  }

  // H make2<H extends NegotiatingField<T>>(String name, String parentID,
  //     Object? parent, H Function(String, String, Object?) constructor) {
  //   return constructor(name, parentID, parent);
  // }

  static Y myConstructor<Y extends NegotiatingField>(
      String name, String parentID, Object? parent) {
    switch (Y) {
      case NegotiatingString:
        return NegotiatingString(name, parentID, parent) as Y;
      case NegotiatingInt:
        return NegotiatingInt(name, parentID, parent) as Y;
      case NegotiatingDay:
        return NegotiatingDay(name, parentID, parent) as Y;
      case NegotiatingHoursAndMinutes:
        return NegotiatingHoursAndMinutes(name, parentID, parent) as Y;
      default:
        throw UnimplementedError();
    }
  }

  static G fromMap<G extends NegotiatingField, T>(
      Map<String, dynamic> map, String name, Object? parent) {
    G nF = myConstructor<G>(name, map['_parentID'], parent)
      ..setIsExcluded(map['_isExcluded'] ?? false, parent)
      ..setIsNegotiated(map['_isNegotiated']);
    map['_hasStringProvisionalValue']
        ? nF.setProvisionalValue(map['_provisionalValue'])
        : {};
    map['_isSelected'] ?? false
        ? nF.setValue((T.toString() == 'DateTime')
            ? DateTime.tryParse(map['_value']) ?? DateTime.now()
            : map['_value'])
        : {};
    nF.updatelVariants((map['_variants'] as List).isEmpty
        ? <T>[]
        : map['_variants'] as List<T>);
    nF.updateProvisionalVariants((map['_provisionalVariants'] as List).isEmpty
        ? <String>[]
        : (map['_provisionalVariants'] as List<dynamic>)
            .map((dyn) => dyn.toString()));
    nF.updatePointAssessments((map['_pointAssesstments'] as Map).isEmpty ||
            (map['_pointAssesstments'][""] as List).isEmpty
        ? <String, List<PointAssessment>>{}
        : (map['_pointAssesstments'] as Map<String, dynamic>).map((key, list) {
            List<PointAssessment> resList = <PointAssessment>[];
            for (var dyn in (list as List<dynamic>)) {
              resList.add(PointAssessment.fromMap(dyn));
            }
            return MapEntry(key, resList);
          }));

    return nF;
  }
}

// someFunc(String name, String parentID, Object? parent) {
//   Map<String, dynamic> map = {};
//   var l = NegotiatingField.fromMap<NegotiatingString>(map, name, parent);
// }
