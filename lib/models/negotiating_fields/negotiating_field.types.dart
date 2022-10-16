part of 'negotiating_field.dart';

class NegotiatingString extends NegotiatingField<String> {
  NegotiatingString(String name, String parentID, Meeting parent)
      : super(name, parentID, parent);

  @override
  NegotiatingString make2<NegotiatingString extends NegotiatingField<String>>(
      String name,
      String parentID,
      Object? parent,
      NegotiatingString Function(String, String, Object?) constructor) {
    return constructor(name, parentID, parent);
  }

  // @override
  // Type get typeOfvalue => String;
}

class NegotiatingInt extends NegotiatingField<int> {
  NegotiatingInt(String name, String parentID, Meeting parent)
      : super(name, parentID, parent);

  // @override
  // Type get typeOfvalue => int;
}

class NegotiatingHoursAndMinutes extends NegotiatingField<DateTime> {
  NegotiatingHoursAndMinutes(String name, String parentID, Meeting parent)
      : super(name, parentID, parent);

  // @override
  // Type get typeOfvalue => DateTime;
  @override
  String mainFormat(Object? val) {
    if (val == null) return '';
    if (val is! DateTime) return val.toString();
    return DateFormat("Hm").format(val);
  }

  @override
  String valueToString() {
    return mainFormat(_value);
  }
}

class NegotiatingDay extends NegotiatingField<DateTime> {
  NegotiatingDay(String name, String parentID, Meeting parent)
      : super(name, parentID, parent);

  // @override
  // Type get typeOfvalue => DateTime;

  @override
  String mainFormat(Object? val) {
    if (val == null) return '';
    if (val is! DateTime) return val.toString();
    return DateFormat("yMMMMd").format(val);
  }

  @override
  String valueToString() {
    return mainFormat(_value);
  }
}
