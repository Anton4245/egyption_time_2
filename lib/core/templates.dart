import 'package:flutter/material.dart';

class MyMainPadding extends StatelessWidget {
  final Widget? child;
  final bool hasBorder;
  const MyMainPadding({Key? key, this.child, this.hasBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }
}
