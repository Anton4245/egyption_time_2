import 'dart:collection';
import 'dart:convert';
import 'package:hive/hive.dart';

import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/participant.dart';
import 'package:ejyption_time_2/models/perticipants.dart';
import 'package:ejyption_time_2/models/probability_assesstment.dart';
import 'package:ejyption_time_2/models/withddd.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'negotiating_field.dart';

part 'meeting.g.dart';

@HiveType(typeId: 1)
class Meeting with ChangeNotifier implements ModifiedObjectInterface<Object> {
  //SERVICE FIELDS

  static const Set<String> possibleNegotiatingFields = {
    '_description',
    '_lenthInDays',
    '_lenthInMinutesAndHours',
    '_shedule',
    '_dayOfMeeting',
    '_timeOfMeeting',
  };

  void provideModifying([bool notify = true]) {
    _version++;
    if (notify) {
      notifyListeners();
    }
  }

  late final Map<String, NegotiatingField> _negotiatingFieldsMap;
  Map<String, NegotiatingField> get negotiatingFieldsMap =>
      _negotiatingFieldsMap;

  @HiveField(10)
  String _id = UniqueKey().toString();
  String get id => _id;
  setId(String id, [bool notify = true]) {
    _id = id;
    provideModifying(notify);
  }

  String myPersonalContactsUniqueKey =
      UniqueKey().toString(); //loaded from database, user to user map

  final Map<String, String> contactsUniqueKey = HashMap(); //for

  @HiveField(11)
  int _version = 0;
  @HiveField(12)
  int _fieldsVersion = 0;
  int get fieldsVersion => _fieldsVersion;
  @HiveField(13)
  String? nameOfLastModifyingField;

  //FOR INTERFACE ModifiedObjectInterface
  @override
  String get nameForModifying => 'meeting';
  @override
  int get version => _version;
  @override
  String get idForModifying => _id;
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
      '_name': _name,
      '_creation': _creation,
      '_finallyNegotiated': _finallyNegotiated
    });
    return m;
  }

  bool fieldsModified = false;

  //DATA FIELDS

  final DateTime _creation = DateTime.now();
  DateTime get creationDateTime => _creation;
  String get creationToString => DateFormat('dd.MM.yy hh:mm').format(_creation);

  String _name = '';
  String get name => _name;
  setName(String n, [bool notify = true]) {
    _name = n;
    provideModifying(notify);
  }

  late final Participants _participants;
  Participants get participants => _participants;

  late final NegotiatingString _description;
  NegotiatingString get description => _description;

  late final NegotiatingInt _lenthInDays;
  NegotiatingInt get lenthInDays => _lenthInDays;

  late final NegotiatingHoursAndMinutes _lenthInMinutesAndHours;
  NegotiatingHoursAndMinutes get lenthInMinutesAndHours =>
      _lenthInMinutesAndHours;

  late final NegotiatingString _shedule;
  NegotiatingString get shedule => _shedule;

  late final NegotiatingDay _dayOfMeeting;
  NegotiatingDay get dayOfMeeting => _dayOfMeeting;

  late final NegotiatingHoursAndMinutes _timeOfMeeting;
  NegotiatingHoursAndMinutes get timeOfMeeting => _timeOfMeeting;

  //list of Assessments
  late final List<ProbabilityAssessment> _probabilitytAssesstments;
  List<ProbabilityAssessment> get probabilitytAssesstments =>
      [..._probabilitytAssesstments];
  void addPointAssesstment(ProbabilityAssessment newProbabilityAssessment,
      [bool notify = true]) {
    _probabilitytAssesstments.add(newProbabilityAssessment);
    _probabilitytAssesstments.sort((a, b) => -a.creation.compareTo(b.creation));
    provideModifying(notify);
  }

  void removePointAssesstment([bool notify = true]) {
    if ((GlobalModel.instance.currentParticipant == null) ||
        _probabilitytAssesstments.isEmpty) {
      return;
    }
    deleteLastListMember(_probabilitytAssesstments);
    provideModifying(notify);
  }

  double calculateProbability() {
    Set<Participant?> wereIncluded = <Participant?>{};
    double sumProbability = 0;
    _probabilitytAssesstments.forEach((element) {
      if (!wereIncluded.contains(element.participant)) {
        sumProbability +=
            (element.probability > 0) ? element.probability / 100 : 0;
        wereIncluded.add(element.participant);
      }
    });
    return sumProbability;
  }

  ProbabilityAssessment? lastProbabilityAssessment() {
    return lastAssessment(_probabilitytAssesstments) as ProbabilityAssessment?;
  }

  bool _finallyNegotiated = false;
  bool get finallyNegotiated => _finallyNegotiated;
  setFinallyNegotiated(bool finallyNegotiated, [bool notify = true]) {
    _finallyNegotiated = finallyNegotiated;
    provideModifying(notify);
  }

  //CONSTRUCTORS AND FUNCTIONS

  Meeting({Set<String>? negotiatingFields}) {
    init(negotiatingFields ?? possibleNegotiatingFields);
  }

  void init(negotiatingFields) {
    _participants = Participants(_id, this);
    _probabilitytAssesstments = <ProbabilityAssessment>[];
    _description = NegotiatingString('_description', _id, this);
    _lenthInDays = NegotiatingInt('_lenthInDays', _id, this);
    _lenthInMinutesAndHours =
        NegotiatingHoursAndMinutes('_lenthInMinutesAndHours', _id, this);
    _shedule = NegotiatingString('_shedule', _id, this);
    _dayOfMeeting = NegotiatingDay('_dayOfMeeting', _id, this);
    _timeOfMeeting = NegotiatingHoursAndMinutes('_timeOfMeeting', _id, this);

    _participants.addListener(() {
      _fieldsVersion++;
      notifyListeners();
    });
    _negotiatingFieldsMap =
        Map.unmodifiable(_initNegotiatingFieldsMap(negotiatingFields));
    _negotiatingFieldsMap.forEach((key, value) {
      value.addListener(() {
        _fieldsVersion++;
        notifyListeners();
      });
    });
  }

  Map<String, NegotiatingField> _initNegotiatingFieldsMap(negotiatingFields) {
    final result = <String, NegotiatingField>{};

    result.addAll({
      _description.name: _description,
      _lenthInDays.name: _lenthInDays,
      _lenthInMinutesAndHours.name: _lenthInMinutesAndHours,
      _shedule.name: _shedule,
      _dayOfMeeting.name: _dayOfMeeting,
      _timeOfMeeting.name: _timeOfMeeting,
    });

    result.forEach((key, value) {
      !negotiatingFields.contains(key) ? value.setIsExcluded(true, this) : {};
    });
    result.removeWhere((key, value) => value.isExcluded);
    return result;
  }

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

  String negotiatingFieldsToString() {
    String result = '';
    _negotiatingFieldsMap.forEach((key, value) {
      result += '$key: ${value.toString()} \n';
    });
    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  @override
  String toString() {
    String result = '_creation: $creationToString\n _name: $_name\n';
    result += negotiatingFieldsToString();
    return result;
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting();
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromMap(json.decode(source));
}
