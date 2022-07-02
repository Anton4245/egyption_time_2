import 'package:ejyption_time_2/models/negotiating_field.dart';
import 'package:ejyption_time_2/models/point_assestment.dart';
import 'package:flutter/material.dart';

enum CommentValues { mark, text }

Future newCommentForm(BuildContext context, String stringToComment,
    void Function(bool, Map<CommentValues, Object?>) callBack) async {
  var _result = false;
  PointMarks _mark = PointMarks.isUnaware;
  String _text = '';

  await showDialog(
    context: context,
    builder: (context) => SizedBox.fromSize(
      size: const Size(double.infinity, 300),
      child: AlertDialog(
        scrollable: true,
        title: Text('Choose assesstment for "${stringToComment}" record:'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text(
              //   'Choose assestment for "${field.toString()}" record:',
              //   style: Theme.of(context)
              //       .textTheme
              //       .subtitle2
              //       ?.copyWith(color: Theme.of(context).colorScheme.primary),
              // ),
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [PointMarks.unFit, PointMarks.soSo, PointMarks.fit]
                    .map((e) => RadioListTile<PointMarks>(
                          activeColor: Theme.of(context).colorScheme.primary,
                          title: Text(pointMarksNames[e] ?? ''),
                          value: e,
                          groupValue: _mark,
                          autofocus: true,
                          onChanged: (PointMarks? value) {
                            setState(() {
                              _mark = value ?? PointMarks.isUnaware;
                            });
                          },
                        ))
                    .toList(),
              ),
              TextField(
                onChanged: (value) => _text = value,
                decoration: const InputDecoration(label: Text('Leave comment')),
                minLines: 2,
                maxLines: 10,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () {
                _result = true;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text('OK')),
          ElevatedButton.icon(
              onPressed: () {
                _result = false;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text('Cancel')),
        ],
      ),
    ),
  );

  callBack(_result, {CommentValues.mark: _mark, CommentValues.text: _text});
}


// return Column(
//       children: <Widget>[
//         RadioListTile<SingingCharacter>(
//           title: const Text('Lafayette'),
//           value: SingingCharacter.lafayette,
//           groupValue: _character,
//           onChanged: (SingingCharacter? value) {
//             setState(() {
//               _character = value;
//             });
//           },
//         ),
//         RadioListTile<SingingCharacter>(
//           title: const Text('Thomas Jefferson'),
//           value: SingingCharacter.jefferson,
//           groupValue: _character,
//           onChanged: (SingingCharacter? value) {
//             setState(() {
//               _character = value;
//             });
//           },
//         ),
//       ],
//     );

// class CommentDialog extends StatelessWidget {
//   const CommentDialog({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         child: Column(
//       children: [
//         RadioListTile(
//             value: value, groupValue: groupValue, onChanged: onChanged)
//       ],
//     ));
//   }
// }
