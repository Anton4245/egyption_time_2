import 'package:ejyption_time_2/core/common_widgets/new_comment.dart';
import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/my_contact.dart';
import 'package:ejyption_time_2/models/participant.dart';
import 'package:ejyption_time_2/models/point_assestment.dart';
import 'package:ejyption_time_2/models/withddd.dart';
import 'package:flutter/widgets.dart';

import 'package:ejyption_time_2/models/negotiating_field.dart';

enum Menu {
  setComment,
  deleteComment,
  provisionalItem,
  clearProvisionalItem,
  valueItem,
  clearValueItem,
  setNegotiatedItem,
  clearNegotiatedItem
}

enum VariantMenu { setComment, deleteComment }

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
      field.modified = true;
      field.updateProvisionalVariants(<String>[]);
    } else if (menuItem == Menu.clearValueItem) {
      field.clearValue(); //TODO handle with field.modified = true;
      field.modified = true;
    } else if (menuItem == Menu.setNegotiatedItem) {
      field.setIsNegotiated(true);
    } else if (menuItem == Menu.clearNegotiatedItem) {
      field.setIsNegotiated(false);
    }
  }

  List<Menu> createMenuList(int commentLength) {
    if ((field.parent as Meeting).finallyNegotiated) return <Menu>[];

    List<Menu> m = <Menu>[];
    m.add(Menu.setComment);
    if (commentLength > 0) {
      m.add(Menu.deleteComment);
    }

    if (GlobalModel.instance.currentParticipant?.isInitiator ?? false) {
      if (field.isNegotiated) {
        m.add(Menu.clearNegotiatedItem);
      } else {
        if (field.isSelected) {
          m.add(Menu.valueItem);
          if (field.value != null) m.add(Menu.clearValueItem);
        } else {
          m.add(Menu.provisionalItem);
          if (field.provisionalValue.isNotEmpty)
            m.add(Menu.clearProvisionalItem);

          m.add(Menu.valueItem);
        }
        m.add(Menu.setNegotiatedItem);
      }
    }

    return m;
  }

  List<VariantMenu> createVariantMenuList(int commentLength) {
    if ((field.parent as Meeting).finallyNegotiated) return <VariantMenu>[];

    List<VariantMenu> m = <VariantMenu>[];
    m.add(VariantMenu.setComment);
    if (commentLength > 0) {
      m.add(VariantMenu.deleteComment);
    }

    return m;
  }

  processResultOfNewComment(
      bool result, Map<CommentValues, Object?> values, keyStringValue) {
    if (result) {
      PointAssessment newAssesstment = PointAssessment(
          participant: GlobalModel.instance.currentParticipant ??
              Participant(
                myContact: MyContact(
                    id: 'Incognito',
                    name: 'Incognito',
                    displayName: 'Incognito'),
              ),
          meetingId: (field.parent as Meeting).id,
          field: field.name,
          keyStringValue: keyStringValue,
          mark: values[CommentValues.mark] as PointMarks,
          commentText: values[CommentValues.text] as String);

      field.addPointAssesstment(newAssesstment, false);
      notifyListeners();
    }
  }

  List<PointAssessment> takeComments(String keyString) {
    List<PointAssessment> comments =
        field.getListOfAssessmentByKeyString(keyString, length: 100);
    deleteListMembersWithTheSameParticipantAndLowerDate(comments);
    return comments;
  }

  void deleteComment(keyStringValue) {
    field.removePointAssesstment(keyStringValue, false);
    notifyListeners();
  }
}
