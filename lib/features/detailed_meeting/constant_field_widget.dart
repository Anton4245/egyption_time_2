import 'package:ejyption_time_2/core/common_widgets/main_popup_menu.dart';
import 'package:ejyption_time_2/core/common_widgets/templates.dart';
import 'package:ejyption_time_2/features/detailed_meeting/constant_field_provider.dart';
import 'package:ejyption_time_2/features/detailed_meeting/meeting_detailed_widget.dart';
import 'package:ejyption_time_2/features/modify_meeting/field_edit_form.dart';
import 'package:ejyption_time_2/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/models/negotiating_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonFieldWidget extends StatelessWidget {
  const CommonFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantFieldProvider model = Provider.of<ConstantFieldProvider>(context);
    if (!model.field.isModifying) {
      return ConstantFieldWidget(model.field);
    } else {
      // ignore: prefer_conditional_assignment
      if (model.field.modifyingFormProvider == null) {
        model.field.modifyingFormProvider = model.createProviderOfNeededType(
            model.field.typeOfvalue, model.field);
      }

      return ChangeNotifierProvider<ModifyingFieldProvider>.value(
          value: model.field.modifyingFormProvider!,
          child: const FieldEditForm());
    }
  }
}

class ConstantFieldWidget extends StatelessWidget {
  final NegotiatingField field;

  // ignore: prefer_const_constructors_in_immutables
  ConstantFieldWidget(
    this.field, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = Provider.of<ConstantFieldProvider>(context, listen: false);
    var currentLabelStyle = theme.textTheme.labelMedium
        ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0x99 / 0xff));
    var currentStatuslStyle =
        theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary);

    return MyMainPadding(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        field.name,
                        style: currentLabelStyle,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              field.isNegotiated
                                  ? 'Negotiated'
                                  : field.isSelected
                                      ? 'In process'
                                      : 'Provisionally',
                              style: field.isNegotiated
                                  ? currentStatuslStyle
                                  : currentLabelStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Icon(
                            field.isNegotiated
                                ? Icons.check_circle
                                : field.isSelected
                                    ? Icons.check_circle_outline
                                    : Icons.circle_outlined,
                            color: field.isNegotiated
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withAlpha(0x99),
                            size: 14,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: field.modified
                            ? theme.colorScheme.tertiaryContainer
                            : null,
                        child: Text(
                          '$field',
                          style: (field.isSelected
                              ? theme.textTheme.subtitle1
                              : theme.textTheme.subtitle2),
                        ),
                      ),
                    ),
                  ],
                ),
                (!field.isNegotiated &&
                        (field.isSelected
                            ? field.variants.isNotEmpty
                            : field.provisionalVariants.isNotEmpty))
                    ? DetailedVariantsWidget(field: field)
                    : const SizedBox.shrink()
              ],
            ),
          ),
          (field.parent as Meeting).finallyNegotiated
              ? const SizedBox.shrink()
              : mainPopupMenu<Menu>(
                  theme,
                  model.createMenuList(field),
                  menuProperties,
                  (menuItem) =>
                      model.setProvisionalValueOnSelected(field, menuItem)),
        ],
      ),
    );
  }
}

const Map<Menu, Map<MenuProp, dynamic>> menuProperties = {
  Menu.provisionalItem: {
    MenuProp.icon: Icons.edit_note,
    MenuProp.text: 'Set provisional value'
  },
  Menu.clearProvisionalItem: {
    MenuProp.icon: Icons.clear,
    MenuProp.text: 'Clear provisional value and variants'
  },
  Menu.valueItem: {MenuProp.icon: Icons.edit_note, MenuProp.text: 'Set value'},
  Menu.clearValueItem: {
    MenuProp.icon: Icons.clear,
    MenuProp.text: 'Clear value'
  },
  Menu.setNegotiatedItem: {
    MenuProp.icon: Icons.check_circle,
    MenuProp.text: 'Set to be negotiated'
  },
  Menu.clearNegotiatedItem: {
    MenuProp.icon: Icons.circle_outlined,
    MenuProp.text: 'Clear to be negotiated'
  }
};
