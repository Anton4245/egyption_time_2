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
