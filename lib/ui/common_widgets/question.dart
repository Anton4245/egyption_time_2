import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> QuestionDialog(BuildContext context, String question) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(question),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.oK),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}
