import 'package:ejyption_time_2/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../core/extenstions.dart' as ttt;

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
  Type get typeOfvalue => String;

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
      return _provisionalValue;
    }

    resultString != '' ? resultString + (_isNegotiated ? ' V' : '') : '';

    return resultString;
  }
}

class NegotiatingString extends NegotiatingField<String> {
  NegotiatingString(String name, String parentID, Object? parent)
      : super(name, parentID, parent);

  @override
  Type get typeOfvalue => String;
}

class NegotiatingInt extends NegotiatingField<int> {
  NegotiatingInt(String name, String parentID, Object? parent)
      : super(name, parentID, parent);

  @override
  Type get typeOfvalue => int;
}

class NegotiatingHoursAndMinutes extends NegotiatingField<DateTime> {
  NegotiatingHoursAndMinutes(String name, String parentID, Object? parent)
      : super(name, parentID, parent);

  @override
  Type get typeOfvalue => DateTime;
  @override
  String mainFormat(Object? val) {
    if (val == null) return '';
    if (val is! DateTime) return '';
    return DateFormat("Hm").format(val);
  }

  @override
  String valueToString() {
    return mainFormat(_value);
  }
}

class NegotiatingDay extends NegotiatingField<DateTime> {
  NegotiatingDay(String name, String parentID, Object? parent)
      : super(name, parentID, parent);

  @override
  Type get typeOfvalue => DateTime;

  @override
  String mainFormat(Object? val) {
    if (val == null) return '';
    if (val is! DateTime) return '';
    return DateFormat("yMMMMd").format(val);
  }

  @override
  String valueToString() {
    return mainFormat(_value);
  }
}
