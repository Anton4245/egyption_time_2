import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/negotiating_field.dart';
import 'package:ejyption_time_2/models/participant.dart';
import 'package:intl/intl.dart';

String keyString(Object? val) {
  if (val == null) {
    return '';
  } else if (val is NegotiatingField) {
    return val.toKeyString();
  } else if (val is DateTime) {
    return DateFormat("yyyyMMddhhmmss").format(val);
  } else {
    try {
      return val.toString();
    } catch (e) {
      return '';
    }
  }
}
