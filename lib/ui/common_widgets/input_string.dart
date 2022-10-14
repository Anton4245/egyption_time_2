import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> displayTextInputDialog(BuildContext context,
    TextEditingController _textFieldController, String answer) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(answer),
        content: TextField(
          controller: _textFieldController,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.oK),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
