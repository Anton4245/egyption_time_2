part of 'meeting.dart';

extension on Meeting {
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      '_id': _id,
      '_creation': _creation,
      '_name': _name,
    });
    result.addAll(negotiatingFieldsMap);
    result.addAll({
      '_finallyNegotiated': _finallyNegotiated,
    });

    return result;
  }
}
