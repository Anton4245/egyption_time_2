import 'package:ejyption_time_2/features/modify_meeting/modifying_field_provider.dart';
import 'package:ejyption_time_2/models/meeting/meeting.dart';
import 'package:ejyption_time_2/models/modified_objects.dart';
import 'package:ejyption_time_2/models/negotiating_fields/negotiating_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//for Git
class FieldEditForm extends StatelessWidget {
  const FieldEditForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // ModifyingFieldProvider model = Provider.of<ModifyingFieldProvider>(context);
    // var ourWidget =
    return Consumer<ModifyingFieldProvider>(
      builder: (context, model, child) {
        model.controller.text = model.field.mainFormat(model.modifyinglValue);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: theme.colorScheme.secondaryContainer.withAlpha(0xAA),
          child: Form(
            key: model.formKey,
            onWillPop: () {
              return model.onWillPop();
            },
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: model.controller,
                        readOnly:
                            model.field.partOfField == PartsOfField.value &&
                                model.field.typeOfvalue == DateTime,
                        keyboardType:
                            (model.field.partOfField == PartsOfField.value &&
                                    model.field.typeOfvalue == int)
                                ? const TextInputType.numberWithOptions(
                                    signed: false, decimal: false)
                                : TextInputType.text,
                        inputFormatters:
                            (model.field.partOfField == PartsOfField.value &&
                                    model.field.typeOfvalue == int)
                                ? [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(
                                        //r'^[-]{0,1}[0-9]*[,]?[0-9]*', //signed regex
                                        r'[0-9]',
                                      ),
                                    ),
                                  ]
                                : [],
                        maxLines: 10,
                        minLines: 1,
                        //focusNode: model.provisionalValueFocusNode,
                        autofocus: (((model.field.parent as Meeting)
                                        .nameOfLastModifyingField ??
                                    '') ==
                                model.field.name)
                            ? true
                            : false,
                        // initialValue:
                        //     model.field.mainFormat(model.modifyinglValue),
                        decoration: InputDecoration(
                          labelText: model.field.name,
                        ),
                        textInputAction: TextInputAction.send,
                        onChanged: (value) =>
                            model.modifyingValueStringOnChange(value),
                        validator: (value) =>
                            model.modifyingValueValidator(value),
                        onSaved: (value) => model.modifyingValueOnSaved(value),
                      ),
                    ),
                    model.field.partOfField == PartsOfField.value &&
                            model.field.typeOfvalue == DateTime
                        ? IconButton(
                            padding: const EdgeInsets.all(8),
                            onPressed: () {
                              if (model.field is NegotiatingDay) {
                                _selectDate(context, model);
                              } else if (model.field
                                  is NegotiatingHoursAndMinutes) {
                                _selectTime(context, model);
                              }
                            },
                            icon: (model.field is NegotiatingDay)
                                ? const Icon(Icons.date_range)
                                : const Icon(Icons.timelapse),
                            color: theme.colorScheme.primary,
                            alignment: Alignment.centerRight,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const VariantsWidget(),
                model.modifyingVariants.isNotEmpty
                    ? const Divider(
                        height: 0,
                        thickness: 2,
                      )
                    : const SizedBox.shrink(),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      IconButton(
                          padding: const EdgeInsets.all(8),
                          onPressed: () => model.save(),
                          icon: Icon(
                            Icons.save,
                            color: theme.colorScheme.primary,
                          )),
                      IconButton(
                          padding: const EdgeInsets.all(8),
                          onPressed: () => model.exit(),
                          icon: Icon(
                            Icons.exit_to_app,
                            color: theme.colorScheme.primary,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

    //FocusScope.of(context).requestFocus(model.provisionalValueFocusNode);
    //return ourWidget;
  }

  _selectDate(BuildContext context, ModifyingFieldProvider model) async {
    DateTime? pickedDate = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        initialDate: model.modifyinglValue ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (pickedDate != null) {
      model.datePicked(pickedDate);
    }
  }

  void _selectTime(BuildContext context, ModifyingFieldProvider model) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      helpText: (model.field.name),
      //initialEntryMode: TimePickerEntryMode.input,
      initialTime: model.modifyinglValue != null
          ? TimeOfDay(
              hour: (model.modifyinglValue as DateTime).hour,
              minute: (model.modifyinglValue as DateTime).minute)
          : const TimeOfDay(hour: 0, minute: 0),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
    if (pickedTime != null) {
      model.timePicked(pickedTime);
    }
  }
}

class VariantsWidget extends StatelessWidget {
  const VariantsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var model = Provider.of<ModifyingFieldProvider>(
        context); //, listen: false - does not work with const in Widget constructor
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: TextButton(
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: theme.colorScheme.primary,
                size: 36,
              ),
              Text(AppLocalizations.of(context)!.addToVariantsList),
            ],
          ),
          onPressed: () {
            model.provisionalValueToVariants();
          },
        )),
        ...model.modifyingVariants.map((val) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: theme.textTheme.bodyText1?.fontSize,
                  width: 20,
                  child: Center(
                    child: Icon(Icons.circle_rounded,
                        size: 8, color: theme.colorScheme.primary),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.field.mainFormat(val),
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.topRight,
                      onPressed: () => model.variantsDelete(val),
                      icon: Icon(
                        Icons.delete,
                        size: (theme.textTheme.bodyText1?.fontSize ?? 16) * 1.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.topRight,
                      onPressed: () => model.variantsMoveUp(val),
                      icon: Icon(
                        Icons.move_up,
                        size: (theme.textTheme.bodyText1?.fontSize ?? 16) * 1.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.topRight,
                      onPressed: () {
                        model.variantsToValue(val);
                      },
                      icon: Icon(
                        Icons.arrow_upward,
                        size: (theme.textTheme.bodyText1?.fontSize ?? 16) * 1.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}
