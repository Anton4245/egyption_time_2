import 'package:ejyption_time_2/core/shared/translate.dart';
import 'package:ejyption_time_2/ui/common_widgets/new_comment.dart';
import 'package:ejyption_time_2/ui/common_widgets/main_popup_menu.dart';
import 'package:ejyption_time_2/ui/common_widgets/templates.dart';
import 'package:ejyption_time_2/models/global/global_model.dart';
import 'package:ejyption_time_2/core/shared/main_functions.dart';
import 'package:ejyption_time_2/ui/features/detailed_meeting/constant_field_provider.dart';
import 'package:ejyption_time_2/ui/features/modify_meeting/field_edit_form.dart';
import 'package:ejyption_time_2/ui/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/negotiating_fields/negotiating_field.dart';
import 'package:ejyption_time_2/models/assesstments/point_assestment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    List<PointAssessment> commentList = model.takeComments(keyString(field));

    return MyMainPadding(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            tR(field.name, context),
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
                                      ? AppLocalizations.of(context)!.negotiated
                                      : field.isSelected
                                          ? AppLocalizations.of(context)!
                                              .inProcess
                                          : AppLocalizations.of(context)!
                                              .provisionally,
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
                                    : theme.colorScheme.onSurface
                                        .withAlpha(0x99),
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
                              field.toString(),
                              style: (field.isSelected
                                  ? theme.textTheme.subtitle1
                                  : theme.textTheme.subtitle2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (field.parent as Meeting).finallyNegotiated
                  ? const SizedBox.shrink()
                  : mainPopupMenu<Menu>(
                      theme,
                      model.createMenuList(commentList.length),
                      menuProperties,
                      (menuItem) => (menuItem == Menu.setComment)
                          ? newCommentForm(
                              context,
                              field.toString(),
                              ((result, values) =>
                                  model.processResultOfNewComment(
                                      result, values, keyString(field))))
                          : (menuItem == Menu.deleteComment)
                              ? model.deleteComment(keyString(field))
                              : model.setProvisionalValueOnSelected(
                                  field, menuItem)),
            ],
          ),
          ...commentList
              .map((PointAssessment pointAssessment) => comment(pointAssessment,
                  theme, theme.textTheme.bodyText1?.fontSize ?? 12))
              .toList(),
          (!field.isNegotiated &&
                  (field.isSelected
                      ? field.variants.isNotEmpty
                      : field.provisionalVariants.isNotEmpty))
              ? DetailedVariantsWidget(model: model)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

Widget comment(PointAssessment pointAssessment, ThemeData theme, double size) {
  return Row(
    children: [
      const Expanded(
        child: SizedBox.shrink(),
        flex: 1,
      ),
      Expanded(
        child: Stack(alignment: AlignmentDirectional.topStart, children: [
          Text('      ${pointAssessment.commentText}',
              style: theme.textTheme.bodyText1?.copyWith(
                  fontSize: size, color: theme.colorScheme.tertiary)),
          Icon(
            pointMarksIcon[pointAssessment.mark],
            color: theme.colorScheme.tertiary,
            size: size * 1.2,
          )
        ]),
        flex: 2,
      ),
    ],
  );
}

class DetailedVariantsWidget extends StatelessWidget {
  final ConstantFieldProvider model;
  const DetailedVariantsWidget({Key? key, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 4,
          ),
          ...((model.field.isSelected)
                  ? model.field.variants
                  : model.field.provisionalVariants)
              .map((val) {
            List<PointAssessment> variantCommentList =
                model.takeComments(keyString(val));
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: model.field.modified
                            ? theme.colorScheme.tertiaryContainer
                            : null,
                        child: Text(
                          ' - ${model.field.mainFormat(val)}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: (model.field.isSelected
                              ? theme.textTheme.bodyText1
                              : theme.textTheme.bodyText2),
                        ),
                      ),
                    ),
                    (model.field.parent as Meeting).finallyNegotiated
                        ? const SizedBox.shrink()
                        : mainPopupMenu<VariantMenu>(
                            theme,
                            model.createVariantMenuList(
                                variantCommentList.length),
                            variantMenuProperties,
                            (menuItem) => (menuItem == VariantMenu.setComment)
                                ? newCommentForm(
                                    context,
                                    model.field.mainFormat(val),
                                    ((result, values) =>
                                        model.processResultOfNewComment(
                                            result, values, keyString(val))))
                                : (menuItem == VariantMenu.deleteComment)
                                    ? model.deleteComment(keyString(val))
                                    : () {},
                            'small'),
                  ],
                ),
                ...variantCommentList
                    .map((PointAssessment pointAssessment) => comment(
                        pointAssessment,
                        theme,
                        (theme.textTheme.bodyText1?.fontSize ?? 12) - 2))
                    .toList()
              ],
            );
          })
        ],
      ),
    );
  }
}

Map<Menu, Map<MenuProp, dynamic>> menuProperties = {
  Menu.provisionalItem: {
    MenuProp.icon: Icons.edit_note,
    MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
        .setProvisionalValue,
  },
  Menu.clearProvisionalItem: {
    MenuProp.icon: Icons.clear,
    MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
        .clearProvisionalValueAndVariants
  },
  Menu.valueItem: {
    MenuProp.icon: Icons.edit_note,
    MenuProp.text:
        AppLocalizations.of(GlobalModel.instance.commonContext!)!.setValue
  },
  Menu.clearValueItem: {
    MenuProp.icon: Icons.clear,
    MenuProp.text:
        AppLocalizations.of(GlobalModel.instance.commonContext!)!.clearValue
  },
  Menu.setNegotiatedItem: {
    MenuProp.icon: Icons.check_circle,
    MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
        .setAsNegotiated
  },
  Menu.clearNegotiatedItem: {
    MenuProp.icon: Icons.circle_outlined,
    MenuProp.text: AppLocalizations.of(GlobalModel.instance.commonContext!)!
        .clearAsNegotiated
  },
  Menu.setComment: {
    MenuProp.icon: Icons.comment,
    MenuProp.text:
        AppLocalizations.of(GlobalModel.instance.commonContext!)!.newComment
  },
  Menu.deleteComment: {
    MenuProp.icon: Icons.clear,
    MenuProp.text:
        AppLocalizations.of(GlobalModel.instance.commonContext!)!.deleteComment
  }
};

Map<VariantMenu, Map<MenuProp, dynamic>> variantMenuProperties = {
  VariantMenu.setComment: {
    MenuProp.icon: Icons.comment,
    MenuProp.text:
        AppLocalizations.of(GlobalModel.instance.commonContext!)!.newComment,
  },
  VariantMenu.deleteComment: {
    MenuProp.icon: Icons.clear,
    MenuProp.text:
        AppLocalizations.of(GlobalModel.instance.commonContext!)!.deleteComment
  }
};
