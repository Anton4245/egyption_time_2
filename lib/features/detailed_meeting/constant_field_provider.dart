import 'package:ejyption_time_2/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:flutter/widgets.dart';

import 'package:ejyption_time_2/models/negotiating_field.dart';

enum Menu {
  provisionalItem,
  clearProvisionalItem,
  valueItem,
  clearValueItem,
  setNegotiatedItem,
  clearNegotiatedItem
}

enum MenuProp { icon, text }

class ConstantFieldProvider with ChangeNotifier {
  final NegotiatingField field;
  ConstantFieldProvider({
    required this.field,
  }) {
    field.addListener(listener);
  }

  listener() {
    notifyListeners();
  }

  @override
  dispose() {
    field.removeListener(listener);
    super.dispose();
  }

  ModifyingFieldProvider<dynamic> createProviderOfNeededType(
      Type t, NegotiatingField value) {
    if (value.partOfField == PartsOfField.provisionalValue || t == String) {
      return ModifyingFieldProvider<String>(
        field: value,
      );
    } else if (t == int) {
      return ModifyingFieldProvider<int>(
        field: value,
      );
    } else if (t == DateTime) {
      return ModifyingFieldProvider<DateTime>(
        field: value,
      );
    } else {
      return ModifyingFieldProvider<Object>(
        field: value,
      );
    }
  }

  setProvisionalValueOnSelected(NegotiatingField field, Menu menuItem) {
    if (menuItem == Menu.valueItem) {
      field.isModifying = true;
      field.partOfField = PartsOfField.value;
      (field.parent as Meeting).nameOfLastModifyingField = field.name;
      (field.parent as Meeting).notifyListeners();
      notifyListeners();
    } else if (menuItem == Menu.provisionalItem) {
      field.isModifying = true;
      field.partOfField = PartsOfField.provisionalValue;
      (field.parent as Meeting).nameOfLastModifyingField = field.name;
      (field.parent as Meeting).notifyListeners();
      notifyListeners();
    } else if (menuItem == Menu.clearProvisionalItem) {
      field.clearProvisionalValue();
    } else if (menuItem == Menu.clearValueItem) {
      field.clearValue();
    } else if (menuItem == Menu.setNegotiatedItem) {
      field.setIsNegotiated(true);
    } else if (menuItem == Menu.clearNegotiatedItem) {
      field.setIsNegotiated(false);
    }
  }

  List<Menu> createMenuList(NegotiatingField<Object> field) {
    if ((field.parent as Meeting).finallyNegotiated) return <Menu>[];

    if (field.isNegotiated) {
      return [Menu.clearNegotiatedItem];
    }

    List<Menu> m = <Menu>[];
    if (field.isSelected) {
      m.add(Menu.valueItem);
      if (field.value != null) m.add(Menu.clearValueItem);
    } else {
      m.add(Menu.provisionalItem);
      if (field.provisionalValue.isNotEmpty) m.add(Menu.clearProvisionalItem);

      m.add(Menu.valueItem);
    }
    m.add(Menu.setNegotiatedItem);

    return m;
  }
}
