enum PartsOfField { provisionalValue, value }

abstract class ModifiedObjectInterface<TypeOfFieldProvider> {
  String get idForModifying;
  String get nameForModifying;
  int get version;
  Map<String, dynamic> mapOfValuableFields();
  bool isModifying = false;
  bool modified = false;
  PartsOfField partOfField = PartsOfField.value;
  TypeOfFieldProvider? modifyingFormProvider;
}

class ModifiedObjects {
  Map<String, Map<String, Object>> objectsMap = {};
}
