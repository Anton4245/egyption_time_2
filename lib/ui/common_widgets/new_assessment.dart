import 'package:ejyption_time_2/models/assesstments/probability_assesstment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ProbabilityValues { mark, probability, text }

Future newAssessmentForm(BuildContext context, String stringToComment,
    void Function(bool, Map<ProbabilityValues, Object?>) callBack) async {
  var _result = false;
  ProbabilityMarks _mark = ProbabilityMarks.isUnaware;
  String _text = '';
  int _probability = 0;
  TextEditingController _c = TextEditingController();
  String? _errorText;

  await showDialog(
      context: context,
      builder: (context) => SizedBox.fromSize(
            size: const Size(double.infinity, 350),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  AlertDialog(
                scrollable: true,
                title: Text(
                    '${AppLocalizations.of(context)!.chooseAssesstmentFor} "$stringToComment" ${AppLocalizations.of(context)!.meeting}:'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProbabilityMarks.mostCertainlyIsNot,
                        ProbabilityMarks.maybe,
                        ProbabilityMarks.possibly,
                        ProbabilityMarks.likely,
                        ProbabilityMarks.veryLikely,
                        ProbabilityMarks.definitelyYes
                      ]
                          .map((e) => RadioListTile<ProbabilityMarks>(
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: -4.0),
                                contentPadding: const EdgeInsets.all(0),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                title: Text(probabilityNames[e] ?? ''),
                                value: e,
                                groupValue: _mark,
                                autofocus: true,
                                onChanged: (ProbabilityMarks? value) {
                                  setState(() {
                                    _mark = value ?? ProbabilityMarks.isUnaware;
                                    _probability =
                                        probabilityNumbers[_mark] ?? 0;
                                    _c.text = _probability.toString();
                                    _errorText = null;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    TextField(
                      controller: _c,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            //r'^[-]{0,1}[0-9]*[,]?[0-9]*   ^-?(?:[1-9][0-9]{0,2})?$', //signed regex
                            r'^-?(?:[1-9][0-9]{0,1})?$',
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        _probability = int.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                          label: Text(
                              '% ${AppLocalizations.of(context)!.ofProbability}'),
                          errorText: _errorText),
                    ),
                    TextField(
                      onChanged: (value) => _text = value,
                      decoration: InputDecoration(
                          label: Text(AppLocalizations.of(context)!
                              .leaveCommentToAssessment)),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton.icon(
                      onPressed: () {
                        if (_mark == ProbabilityMarks.isUnaware) {
                          setState(() {
                            _errorText = AppLocalizations.of(context)!
                                .chooseAnyVariantFromListAbove;
                          });

                          return;
                        }

                        _result = true;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: Text(AppLocalizations.of(context)!.oK)),
                  ElevatedButton.icon(
                      onPressed: () {
                        _result = false;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: Text(AppLocalizations.of(context)!.cancel)),
                ],
              ),
            ),
          ));

  callBack(_result, {
    ProbabilityValues.mark: _mark,
    ProbabilityValues.probability: _probability,
    ProbabilityValues.text: _text
  });
}
