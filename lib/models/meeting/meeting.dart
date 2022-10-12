import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/participants/participant.dart';
import 'package:ejyption_time_2/models/participants/participants.dart';
import 'package:ejyption_time_2/models/probability_assesstment.dart';
import 'package:ejyption_time_2/models/withddd.dart';

import '../negotiating_fields/negotiating_field.dart';

part 'meeting.g.dart';
part 'meeting.serial.dart';

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

  String _id = UniqueKey().toString();
  String get id => _id;
  setId(String id, [bool notify = true]) {
    _id = id;
    provideModifying(notify);
  }

  String myPersonalContactsUniqueKey = UniqueKey().toString(); //from database

  final Map<String, String> contactsUniqueKey = HashMap(); //for

  int _version = 0;
  int _fieldsVersion = 0;
  int get fieldsVersion => _fieldsVersion;
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

  late final DateTime _creation;
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
    for (var element in _probabilitytAssesstments) {
      if (!wereIncluded.contains(element.participant)) {
        sumProbability +=
            (element.probability > 0) ? element.probability / 100 : 0;
        wereIncluded.add(element.participant);
      }
    }
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
    _creation = DateTime.now();
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

  Meeting.forJSON(
    List<String> negotiatingFields,
    myPersonalContactsUniqueKey,
    _version,
    _fieldsVersion,
    modified,
    fieldsModified,
    _creation,
    _name,
    participantsMap,
    descriptionMap,
    lenthInDaysMap,
    lenthInMinutesAndHoursMap,
    sheduleMap,
    dayOfMeetingMap,
    timeOfMeetingMap,
    _probabilitytAssesstments,
    _finallyNegotiated,
  ) {
    Participants.fromMap(participantsMap, this);
    NegotiatingField.fromMap<NegotiatingString, String>(
        descriptionMap, '_description', this);
    NegotiatingField.fromMap<NegotiatingInt, int>(
        lenthInDaysMap, '_lenthInDays', this);
    NegotiatingField.fromMap<NegotiatingHoursAndMinutes, DateTime>(
        lenthInMinutesAndHoursMap, '_lenthInMinutesAndHours', this);
    NegotiatingField.fromMap<NegotiatingString, String>(
        sheduleMap, '_shedule', this);
    NegotiatingField.fromMap<NegotiatingDay, DateTime>(
        dayOfMeetingMap, '_dayOfMeeting', this);
    NegotiatingField.fromMap<NegotiatingHoursAndMinutes, DateTime>(
        timeOfMeetingMap, '_timeOfMeeting', this);

    _initNegotiatingFieldsMap(negotiatingFields);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      '_negotiatingFields':
          _negotiatingFieldsMap.entries.map((e) => e.key).toList()
    });
    result.addAll({'myPersonalContactsUniqueKey': myPersonalContactsUniqueKey});
    result.addAll({'_version': _version});
    result.addAll({'_fieldsVersion': _fieldsVersion});
    result.addAll({'modified': modified});
    result.addAll({'fieldsModified': fieldsModified});
    result.addAll({'_creation': _creation});
    result.addAll({'_name': _name});
    result.addAll({'_participants': _participants.toMap()});
    result.addAll({'_description': _description.toMap()});
    result.addAll({'_lenthInDays': _lenthInDays.toMap()});
    result.addAll({'_lenthInMinutesAndHours': _lenthInMinutesAndHours.toMap()});
    result.addAll({'_shedule': _shedule.toMap()});
    result.addAll({'_dayOfMeeting': _dayOfMeeting.toMap()});
    result.addAll({'_timeOfMeeting': _timeOfMeeting.toMap()});
    result.addAll({
      '_probabilitytAssesstments': _probabilitytAssesstments
          .map((assestment) => assestment.toMap())
          .toList()
    });
    result.addAll({'_finallyNegotiated': _finallyNegotiated});

    return result;
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting.forJSON(
      map['_negotiatingFields'],
      map['myPersonalContactsUniqueKey'] ?? '',
      map['_version']?.toInt() ?? 0,
      map['_fieldsVersion']?.toInt() ?? 0,
      map['modified'] ?? false,
      map['fieldsModified'] ?? false,
      map['_creation'],
      map['_name'] ?? '',
      map['_participants'],
      map['_description'],
      map['_lenthInDays'],
      map['_lenthInMinutesAndHours'],
      map['_shedule'],
      map['_dayOfMeeting'],
      map['_timeOfMeeting'],
      (map['_probabilitytAssesstments'] as List<Map<String, dynamic>>)
          .map((map) => ProbabilityAssessment.fromMap(map))
          .toList(),
      map['_finallyNegotiated'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromMap(json.decode(source));
}
