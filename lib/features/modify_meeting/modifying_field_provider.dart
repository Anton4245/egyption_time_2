import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:ejyption_time_2/models/negotiating_field.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/time.dart';
import '../../core/extenstions.dart';

class ModifyingFieldProvider<E> with ChangeNotifier {
  NegotiatingField field;

  var formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  //final formKey = GlobalKey();
  int _version = 1;
  int get version => _version;

  String? errorText;
  final provisionalValueFocusNode = FocusNode();

  //DATA FIELDS
  late E? modifyinglValue;
  late List<E?> modifyingVariants;

  //constructor
  ModifyingFieldProvider({
    required this.field,
  }) {
    if (field.partOfField == PartsOfField.provisionalValue) {
      modifyinglValue = field.provisionalValue as E;
      modifyingVariants = [...field.provisionalVariants] as List<E>;
    } else if (field.partOfField == PartsOfField.value) {
      modifyinglValue = field.value as E?;
      modifyingVariants = [...(field.variants) as List<E?>];
    }
  }

  void provideModifying() {
    _version++;
    notifyListeners();
  }

  //WORK WITH provisionalValue
  void modifyingValueStringOnChange(val) {
    if (field.partOfField == PartsOfField.provisionalValue ||
        field.typeOfvalue == String) {
      modifyinglValue = val;
    } else if (field.typeOfvalue == int) {
      modifyinglValue = (int.tryParse(val ?? '') ?? 0) as E?;
    } else {
      //do nothing, do not use value of TextField
    }
  }

  String? modifyingValueValidator(String? val) {
    if ((field.partOfField == PartsOfField.value) && (val?.isEmpty ?? true)) {
      return 'Please provide a value';
    } else if (field.partOfField == PartsOfField.value &&
        field.typeOfvalue == int) {
      int temp = int.tryParse(val ?? '') ?? 0;
      if (temp == 0) {
        return 'Value must be a round number';
      }
      if (temp < 0) {
        return 'Value must be a positive number';
      }
    }
    return null;
  }

  void datePicked(DateTime? pickedDate) {
    if (field.typeOfvalue == DateTime) {
      modifyinglValue = pickedDate as E?;
      provideModifying();
    }
  }

  void timePicked(TimeOfDay? pickedTime) {
    if (field.typeOfvalue == DateTime) {
      modifyinglValue =
          DateTime(1, 1, 1, pickedTime?.hour ?? 0, pickedTime?.minute ?? 0)
              as E?;
      provideModifying();
    }
  }

  Future<bool> onWillPop() async {
    (field.parent as Meeting).nameOfLastModifyingField = '';
    return true;
  }

  //WORK WITH provisionalVariants

  variantsDelete(E? val) {
    modifyingVariants.removeWhere((element) => element == val);
    provideModifying();
  }

  variantsMoveUp(E? val) {
    if (modifyingVariants.moveUpMy(val)) {
      provideModifying();
    }
  }

  variantsToValue(E? val) {
    modifyinglValue = val;
    modifyingVariants.removeWhere((element) => element == val);
    provideModifying();
  }

  void provisionalValueToVariants() {
    modifyingVariants.addSmartMy(modifyinglValue);
    modifyinglValue = ((field.partOfField == PartsOfField.provisionalValue)
        ? ''
        : null) as E?;
    provideModifying();
  }

  //MODIFYING GLOBAL OBJECTS

  void modifyingValueOnSaved(val) {
    //empty
  }

  void save() {
    bool res = formKey.currentState?.validate() ?? false;
    if (!res) return;
    field.isModifying = false;
    field.modifyingFormProvider = null;

    if (field.partOfField == PartsOfField.provisionalValue) {
      field.setProvisionalValue(modifyinglValue as String);
      field.updateProvisionalVariants(modifyingVariants as List<String>);
    } else if (field.partOfField == PartsOfField.value) {
      field.setValue(modifyinglValue);
      field.updatelVariants(modifyingVariants);
    }

    field.modified = true;
    (field.parent as Meeting).fieldsModified = true;
    formKey.currentState?.save();
  }

  void exit() {
    field.isModifying = false;
    field.modifyingFormProvider = null;
    field.notifyListeners();
  }
}
